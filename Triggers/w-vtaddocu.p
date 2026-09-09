TRIGGER PROCEDURE FOR WRITE OF VtaDDocu.

/*     FIND Almmmatg OF VtaDDocu NO-LOCK NO-ERROR.                               */
/*     FIND FIRST Vtacdocu OF Vtaddocu NO-LOCK NO-ERROR.                         */
/*     IF AVAILABLE Almmmatg AND AVAILABLE Vtacdocu THEN DO:                     */
/*         /* MARGEN */                                                          */
/*         DEFINE VAR X-COSTO  AS DECI INIT 0 NO-UNDO.                           */
/*         DEFINE VAR X-MARGEN AS DECI INIT 0 NO-UNDO.                           */
/*                                                                               */
/*         X-COSTO = 0.                                                          */
/*         IF Vtaddocu.Factor = 0 THEN Vtaddocu.Factor = 1.                      */
/*         IF Vtacdocu.CodMon = 1 THEN DO:                                       */
/*            IF Almmmatg.MonVta = 1                                             */
/*            THEN ASSIGN X-COSTO = (Almmmatg.Ctotot).                           */
/*            ELSE ASSIGN X-COSTO = (Almmmatg.Ctotot) * Vtacdocu.Tpocmb.         */
/*         END.                                                                  */
/*         IF Vtacdocu.CodMon = 2 THEN DO:                                       */
/*            IF Almmmatg.MonVta = 2                                             */
/*            THEN ASSIGN X-COSTO = (Almmmatg.Ctotot).                           */
/*            ELSE ASSIGN X-COSTO = (Almmmatg.Ctotot) / Vtacdocu.Tpocmb.         */
/*         END.                                                                  */
/*         X-COSTO = X-COSTO * Vtaddocu.CanPed * Vtaddocu.Factor.                */
/*         X-MARGEN = ROUND( ((( Vtaddocu.ImpLin / X-COSTO ) - 1 ) * 100 ), 2 ). */
/*         IF x-Costo <> 0                                                       */
/*         THEN ASSIGN                                                           */
/*             VtaDDocu.ImpCto = x-Costo                                         */
/*             VtaDDocu.MrgUti = x-Margen.                                       */
/*     END.                                                                      */
