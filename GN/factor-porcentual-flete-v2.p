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
    Notes       : Factor Gerencia General
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEFINE INPUT PARAMETER pListaPrecio AS CHAR.
DEFINE INPUT PARAMETER x-codmat AS CHAR.
DEFINE INPUT-OUTPUT PARAMETER x-flete AS DEC.
DEFINE INPUT PARAMETER x-tpoped AS CHAR.    /* Tipo de Pedido */
DEFINE INPUT PARAMETER pf-factor AS DEC.
DEFINE INPUT PARAMETER ps-codmon AS INT.

DEFINE SHARED VAR s-codcia AS INT.
DEFINE VAR x-factor-porcentual-flete AS DEC INIT 0.

/* Validación */
IF x-Flete <= 0 THEN RETURN.

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
         HEIGHT             = 5.04
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

DEFINE BUFFER x-almmmatg FOR almmmatg.
DEFINE BUFFER x-vtatabla FOR vtatabla.

DEFINE VAR SW-LOG1 AS LOG.
DEFINE VAR x-precio AS DEC.
DEFINE VAR x-factor AS DEC INIT 0.
DEFINE VAR x-calc-fac AS DEC INIT 0.
DEFINE VAR x-prevta1 AS DEC INIT 0.
DEFINE VAR x-prevta2 AS DEC INIT 0.
DEFINE VAR x-prevta AS DEC INIT 0.


FIND FIRST x-almmmatg WHERE x-almmmatg.codcia = s-codcia AND 
    x-almmmatg.codmat = x-codmat NO-LOCK NO-ERROR.
IF NOT AVAILABLE x-almmmatg THEN RETURN.

    IF x-almmmatg.codmat = "077417" THEN DO:
        /*MESSAGE "x-flete" x-flete.*/
    END.


/* Chequear si la familia entra a la formula de factor (1.5%) */
FIND FIRST x-vtatabla WHERE x-vtatabla.codcia = s-codcia AND
    x-vtatabla.tabla = 'FACTORPORFLETE' AND
    x-vtatabla.llave_c1 = pListaPrecio AND
    x-vtatabla.llave_c2 = x-almmmatg.codfam NO-LOCK NO-ERROR.
IF NOT AVAILABLE x-vtatabla THEN DO:
    /* Si no esta se le cobra Flete */    
    RETURN.
END.
x-factor-porcentual-flete = x-vtatabla.valor[1]. /* 1.5% */
/* *********************** */
/* RHC: ACUERDO 27/12/2018 */
/* *********************** */
SW-LOG1 = NO.
/* Precios a tomar A,B,C */
/****   PRECIO C    ****/
IF x-Almmmatg.UndC > ""  THEN DO:
    /* ******************************** */
    FIND Almtconv WHERE Almtconv.CodUnid = x-Almmmatg.UndBas 
        AND  Almtconv.Codalter = x-Almmmatg.UndC 
        NO-LOCK NO-ERROR.
    IF AVAILABLE Almtconv THEN X-FACTOR = Almtconv.Equival.
/*     ELSE MESSAGE 'ARTICULO:' x-CodMat SKIP                                     */
/*         'NO configurada la equivalencia para la unidad C' SKIP                 */
/*         'Avisar al gestor del maestro de artículos' VIEW-AS ALERT-BOX WARNING. */
    IF AVAILABLE Almtconv /*AND (x-CanPed * F-FACTOR) >= (0.25 * X-FACTOR)*/ THEN DO:
        SW-LOG1 = TRUE.
        IF x-Almmmatg.MonVta = 1 THEN
          ASSIGN X-PREVTA1 = x-Almmmatg.Prevta[4]
                 X-PREVTA2 = ROUND(X-PREVTA1 / x-Almmmatg.TpoCmb,6).
        ELSE
          ASSIGN X-PREVTA2 = x-Almmmatg.Prevta[4]
                 X-PREVTA1 = ROUND(X-PREVTA2 * x-Almmmatg.TpoCmb,6).
        X-PREVTA1 = (X-PREVTA1 / X-FACTOR) * pF-FACTOR.
        X-PREVTA2 = (X-PREVTA2 / X-FACTOR) * pF-FACTOR.
    END.
END.
/****   PRECIO B    ****/
IF x-Almmmatg.UndB > "" AND NOT sw-log1 THEN DO:
    FIND Almtconv WHERE Almtconv.CodUnid = x-Almmmatg.UndBas 
        AND  Almtconv.Codalter = x-Almmmatg.UndB 
        NO-LOCK NO-ERROR.
    IF AVAILABLE Almtconv THEN X-FACTOR = Almtconv.Equival.
/*     ELSE MESSAGE 'ARTICULO:' x-CodMat SKIP                                     */
/*         'NO configurada la equivalencia para la unidad B' SKIP                 */
/*         'Avisar al gestor del maestro de artículos' VIEW-AS ALERT-BOX WARNING. */
    IF AVAILABLE Almtconv /*AND (x-CanPed * F-FACTOR) >= (0.25 * X-FACTOR)*/ THEN DO:
        SW-LOG1 = TRUE.
        IF x-Almmmatg.MonVta = 1 THEN 
          ASSIGN X-PREVTA1 = x-Almmmatg.Prevta[3]
                 X-PREVTA2 = ROUND(X-PREVTA1 / x-Almmmatg.TpoCmb,6).
        ELSE
          ASSIGN X-PREVTA2 = x-Almmmatg.Prevta[3]
                 X-PREVTA1 = ROUND(X-PREVTA2 * x-Almmmatg.TpoCmb,6).
        X-PREVTA1 = (X-PREVTA1 / X-FACTOR) * pF-FACTOR.
        X-PREVTA2 = (X-PREVTA2 / X-FACTOR) * pF-FACTOR.
    END.
END.
/****   PRECIO A    ****/
IF x-Almmmatg.UndA > "" AND NOT SW-LOG1 THEN DO:
    FIND Almtconv WHERE Almtconv.CodUnid = x-Almmmatg.UndBas 
        AND  Almtconv.Codalter = x-Almmmatg.UndA 
        NO-LOCK NO-ERROR.
    IF AVAILABLE Almtconv THEN X-FACTOR = Almtconv.Equival.
/*     ELSE MESSAGE 'ARTICULO:' x-CodMat SKIP                                     */
/*         'NO configurada la equivalencia para la unidad A' SKIP                 */
/*         'Avisar al gestor del maestro de artículos' VIEW-AS ALERT-BOX WARNING. */
    IF AVAILABLE Almtconv /*AND (x-CanPed * F-FACTOR) >= (0.25 * X-FACTOR)*/ THEN DO:
        SW-LOG1 = TRUE.
        IF x-Almmmatg.MonVta = 1 THEN 
          ASSIGN X-PREVTA1 = x-Almmmatg.Prevta[2]
                 X-PREVTA2 = ROUND(X-PREVTA1 / x-Almmmatg.TpoCmb,6).
        ELSE
          ASSIGN X-PREVTA2 = x-Almmmatg.Prevta[2]
                 X-PREVTA1 = ROUND(X-PREVTA2 * x-Almmmatg.TpoCmb,6).
        X-PREVTA1 = (X-PREVTA1 / X-FACTOR) * pF-FACTOR.
        X-PREVTA2 = (X-PREVTA2 / X-FACTOR) * pF-FACTOR.
    END.
    ELSE DO:
        SW-LOG1 = TRUE.

        IF x-Almmmatg.MonVta = 1 THEN 
          ASSIGN X-PREVTA1 = x-Almmmatg.Prevta[2]
                 X-PREVTA2 = ROUND(X-PREVTA1 / x-Almmmatg.TpoCmb,6).
        ELSE
          ASSIGN X-PREVTA2 = x-Almmmatg.Prevta[2]
                 X-PREVTA1 = ROUND(X-PREVTA2 * x-Almmmatg.TpoCmb,6).
        X-PREVTA1 = (X-PREVTA1 / X-FACTOR) * pF-FACTOR.
        X-PREVTA2 = (X-PREVTA2 / X-FACTOR) * pF-FACTOR.
    END.
END.               

IF X-PREVTA1 + X-PREVTA2 > 0 THEN DO:
    IF pS-CODMON = 1 
    THEN x-PREVTA = X-PREVTA1.
    ELSE x-PREVTA = X-PREVTA2.     
END.      

IF x-PREVTA > 0 THEN DO:
    x-calc-fac = (x-flete / x-prevta) * 100.

    IF x-almmmatg.codmat = "077417" THEN DO:
        /*
        MESSAGE "x-PREVTA " x-PREVTA SKIP                
            "x-flete" x-flete SKIP
            "x-prevta" x-prevta SKIP
            "x-calc-fac" x-calc-fac SKIP
            "x-factor-porcentual-flete" x-factor-porcentual-flete.
        */
    END.

    /* Si es menor , flete = 0 */
    IF x-calc-fac < x-factor-porcentual-flete  THEN x-flete = 0.
END.         

    IF x-almmmatg.codmat = "077417" THEN DO:
        /*MESSAGE "x-flete" x-flete.*/
    END.


RETURN.

/* CASE x-TpoPed:                                                                                                */
/*     WHEN "E" THEN DO:       /* EXPOLIBRERIA */                                                                */
/*         FIND FIRST vtalistamay WHERE vtalistamay.codcia = s-codcia AND                                        */
/*             vtalistamay.coddiv = pListaPrecio AND                                                             */
/*             vtalistamay.codmat = x-codmat NO-LOCK NO-ERROR.                                                   */
/*         IF AVAILABLE vtalistamay THEN DO:                                                                     */
/*             FIND Almtconv WHERE Almtconv.CodUnid = x-Almmmatg.UndBas                                          */
/*                 AND  Almtconv.Codalter = vtalistamay.CHR__01                                                  */
/*                 NO-LOCK NO-ERROR.                                                                             */
/*             IF AVAILABLE Almtconv THEN X-FACTOR = Almtconv.Equival.                                           */
/*             ELSE MESSAGE 'FLETE - NO configurada la equivalencia en VTALISTAMAY' VIEW-AS ALERT-BOX WARNING.   */
/*             IF AVAILABLE Almtconv  THEN DO:                                                                   */
/*                                                                                                               */
/*                 IF vtalistamay.MonVta = 1 THEN                                                                */
/*                   ASSIGN X-PREVTA1 = vtalistamay.preofi                                                       */
/*                          X-PREVTA2 = ROUND(X-PREVTA1 / vtalistamay.TpoCmb,6).                                 */
/*                 ELSE                                                                                          */
/*                   ASSIGN X-PREVTA2 = vtalistamay.preofi                                                       */
/*                          X-PREVTA1 = ROUND(X-PREVTA2 * vtalistamay.TpoCmb,6).                                 */
/*                 X-PREVTA1 = (X-PREVTA1 / X-FACTOR) * pF-FACTOR.                                               */
/*                 X-PREVTA2 = (X-PREVTA2 / X-FACTOR) * pF-FACTOR.                                               */
/*             END.                                                                                              */
/*                                                                                                               */
/*         END.                                                                                                  */
/*                                                                                                               */
/*     END.                                                                                                      */
/*     OTHERWISE DO:   /* TIENDAS */                                                                             */
/*         SW-LOG1 = NO.                                                                                         */
/*         /* Precios a tomar A,B,C */                                                                           */
/*         /****   PRECIO C    ****/                                                                             */
/*         IF x-Almmmatg.UndC <> ""  THEN DO:                                                                    */
/*             /* ******************************** */                                                            */
/*             FIND Almtconv WHERE Almtconv.CodUnid = x-Almmmatg.UndBas                                          */
/*                 AND  Almtconv.Codalter = x-Almmmatg.UndC                                                      */
/*                 NO-LOCK NO-ERROR.                                                                             */
/*             IF AVAILABLE Almtconv THEN X-FACTOR = Almtconv.Equival.                                           */
/*             ELSE MESSAGE 'FLETE - NO configurada la equivalencia para la unidad C' VIEW-AS ALERT-BOX WARNING. */
/*             IF AVAILABLE Almtconv /*AND (x-CanPed * F-FACTOR) >= (0.25 * X-FACTOR)*/ THEN DO:                 */
/*                 SW-LOG1 = TRUE.                                                                               */
/*                                                                                                               */
/*                 IF x-Almmmatg.MonVta = 1 THEN                                                                 */
/*                   ASSIGN X-PREVTA1 = x-Almmmatg.Prevta[4]                                                     */
/*                          X-PREVTA2 = ROUND(X-PREVTA1 / x-Almmmatg.TpoCmb,6).                                  */
/*                 ELSE                                                                                          */
/*                   ASSIGN X-PREVTA2 = x-Almmmatg.Prevta[4]                                                     */
/*                          X-PREVTA1 = ROUND(X-PREVTA2 * x-Almmmatg.TpoCmb,6).                                  */
/*                 X-PREVTA1 = (X-PREVTA1 / X-FACTOR) * pF-FACTOR.                                               */
/*                 X-PREVTA2 = (X-PREVTA2 / X-FACTOR) * pF-FACTOR.                                               */
/*             END.                                                                                              */
/*         END.                                                                                                  */
/*                                                                                                               */
/*         /****   PRECIO B    ****/                                                                             */
/*         IF x-Almmmatg.UndB <> "" AND NOT sw-log1 THEN DO:                                                     */
/*             FIND Almtconv WHERE Almtconv.CodUnid = x-Almmmatg.UndBas                                          */
/*                 AND  Almtconv.Codalter = x-Almmmatg.UndB                                                      */
/*                 NO-LOCK NO-ERROR.                                                                             */
/*             IF AVAILABLE Almtconv THEN X-FACTOR = Almtconv.Equival.                                           */
/*             ELSE MESSAGE 'NO configurada la equivalencia para la unidad B' VIEW-AS ALERT-BOX WARNING.         */
/*             IF AVAILABLE Almtconv /*AND (x-CanPed * F-FACTOR) >= (0.25 * X-FACTOR)*/ THEN DO:                 */
/*                 SW-LOG1 = TRUE.                                                                               */
/*                 IF x-Almmmatg.MonVta = 1 THEN                                                                 */
/*                   ASSIGN X-PREVTA1 = x-Almmmatg.Prevta[3]                                                     */
/*                          X-PREVTA2 = ROUND(X-PREVTA1 / x-Almmmatg.TpoCmb,6).                                  */
/*                 ELSE                                                                                          */
/*                   ASSIGN X-PREVTA2 = x-Almmmatg.Prevta[3]                                                     */
/*                          X-PREVTA1 = ROUND(X-PREVTA2 * x-Almmmatg.TpoCmb,6).                                  */
/*                 X-PREVTA1 = (X-PREVTA1 / X-FACTOR) * pF-FACTOR.                                               */
/*                 X-PREVTA2 = (X-PREVTA2 / X-FACTOR) * pF-FACTOR.                                               */
/*             END.                                                                                              */
/*         END.                                                                                                  */
/*         /****   PRECIO A    ****/                                                                             */
/*         IF x-Almmmatg.UndA <> "" AND NOT SW-LOG1 THEN DO:                                                     */
/*             FIND Almtconv WHERE Almtconv.CodUnid = x-Almmmatg.UndBas                                          */
/*                 AND  Almtconv.Codalter = x-Almmmatg.UndA                                                      */
/*                 NO-LOCK NO-ERROR.                                                                             */
/*             IF AVAILABLE Almtconv THEN X-FACTOR = Almtconv.Equival.                                           */
/*             ELSE MESSAGE 'NO configurada la equivalencia para la unidad A' VIEW-AS ALERT-BOX WARNING.         */
/*             IF AVAILABLE Almtconv /*AND (x-CanPed * F-FACTOR) >= (0.25 * X-FACTOR)*/ THEN DO:                 */
/*                 SW-LOG1 = TRUE.                                                                               */
/*                 IF x-Almmmatg.MonVta = 1 THEN                                                                 */
/*                   ASSIGN X-PREVTA1 = x-Almmmatg.Prevta[2]                                                     */
/*                          X-PREVTA2 = ROUND(X-PREVTA1 / x-Almmmatg.TpoCmb,6).                                  */
/*                 ELSE                                                                                          */
/*                   ASSIGN X-PREVTA2 = x-Almmmatg.Prevta[2]                                                     */
/*                          X-PREVTA1 = ROUND(X-PREVTA2 * x-Almmmatg.TpoCmb,6).                                  */
/*                 X-PREVTA1 = (X-PREVTA1 / X-FACTOR) * pF-FACTOR.                                               */
/*                 X-PREVTA2 = (X-PREVTA2 / X-FACTOR) * pF-FACTOR.                                               */
/*             END.                                                                                              */
/*             ELSE DO:                                                                                          */
/*                 SW-LOG1 = TRUE.                                                                               */
/*                                                                                                               */
/*                 IF x-Almmmatg.MonVta = 1 THEN                                                                 */
/*                   ASSIGN X-PREVTA1 = x-Almmmatg.Prevta[2]                                                     */
/*                          X-PREVTA2 = ROUND(X-PREVTA1 / x-Almmmatg.TpoCmb,6).                                  */
/*                 ELSE                                                                                          */
/*                   ASSIGN X-PREVTA2 = x-Almmmatg.Prevta[2]                                                     */
/*                          X-PREVTA1 = ROUND(X-PREVTA2 * x-Almmmatg.TpoCmb,6).                                  */
/*                 X-PREVTA1 = (X-PREVTA1 / X-FACTOR) * pF-FACTOR.                                               */
/*                 X-PREVTA2 = (X-PREVTA2 / X-FACTOR) * pF-FACTOR.                                               */
/*             END.                                                                                              */
/*         END.                                                                                                  */
/*     END.                                                                                                      */
/* END CASE.                                                                                                     */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


