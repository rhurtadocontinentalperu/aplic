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
/*     DEFINE VAR X-RANGO AS INTEGER INIT 0. */
/*     DEFINE VAR X-CANTI AS DECI    INIT 0. */

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


