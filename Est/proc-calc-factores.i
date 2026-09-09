
lMaxVtas = 0.
lMaxMargen = 0.
lMaxFCreci = 0.
lCount = 1.

/* Maximo de Ventas */
FOR EACH {&tabla} USE-INDEX IdxVtas :
    lMaxVtas = {&tabla}.VtaxMesMn_act.
    IF lMaxVtas > 0 THEN LEAVE.
END.

/* Maximo de Margen */
FOR EACH {&tabla} USE-INDEX IdxMargen :
    lMaxMargen = {&tabla}.margen_act.
    IF lMaxMargen > 0 THEN LEAVE.
END.

/* Factor de Crecimiento */
FOR EACH {&tabla} USE-INDEX IdxCreci :
    IF lCount = pFactor THEN DO:
        lMaxFCreci = {&tabla}.fcrecimiento.
    END.
    lCount = lCount + 1.
END.

/* Calculo lo Factores de todos los Articulos*/
FOR EACH {&tabla} :
    /*
    txt-msg:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "FASE #2 - FACTORES..." + ' / ' + 
        detalle.codmat + ' ' + detalle.producto. 
    */
    /* Ventas */
    ASSIGN {&tabla}.fVentas = ROUND( {&tabla}.VtaxMesMn_act / lMaxVtas , 6).
    /* Margen */
    ASSIGN {&tabla}.fMargen = ROUND( {&tabla}.margen_act / lMaxMargen , 6).
    /* Factor Crecimiento */
    IF {&tabla}.fcrecimiento >= lMaxFCreci THEN DO:
        ASSIGN {&tabla}.fcreci = 1.
    END.
    ELSE DO:
        ASSIGN {&tabla}.fcreci = ROUND( {&tabla}.fcrecimiento / lMaxFCreci , 6).
    END.
    ASSIGN {&tabla}.fVentas1 = ROUND( {&tabla}.fVentas * (pVenta / 100) , 6)
            {&tabla}.fMargen1 = ROUND( {&tabla}.fMargen * (pMargen / 100) , 6)
            {&tabla}.fCreci1 = ROUND( {&tabla}.fCreci * (pCreci / 100) , 6).
    ASSIGN {&tabla}.sumafactor = {&tabla}.fVentas1 + {&tabla}.fMargen1 + {&tabla}.fCreci1.
END.

lRanking    = 0.    /* Nivel de cada ranking A, B, C, D,...F */
lRank       = "".  /* Clasificacion */
lRegsRank   = -1.
lRegCount   = 0.
lCount      = 1.    /* El Ranking */

FOR EACH {&tabla} USE-INDEX IdxSumFac :
    IF lRegsRank < lRegCount THEN DO:
        /* Cambia de Ranking */
        lRanking = lRanking + 1.
        IF lRanking <= 1 AND lqValor_A > 0 THEN DO:
            /* Nivel del Ranking A */
           lRegsRank = lqValor_A.
           lRank = IF ( p-especial = no) THEN 'A' ELSE 'NA'.
           lRegCount = 1.   /* Reseteo contador de cada ranking */
           lRanking = 1.   /* Reseteo contador de cada ranking */
        END.
        ELSE  DO:
            IF lRanking <= 2 AND lqValor_B > 0 THEN DO:
                /* Nivel del Ranking B */
                lRegsRank = lqValor_B.
                lRank = IF (p-especial=no) THEN 'B' ELSE 'NB'.
                lRegCount = 1.
                lRanking = 2.
            END.
            ELSE DO:
                IF lRanking <= 3 AND lqValor_C > 0 THEN DO:
                    /* Nivel del Ranking C */
                    lRegsRank = lqValor_C.
                    lRank = IF (p-especial = no) THEN 'C' ELSE 'NC'.
                    lRegCount = 1.
                    lRanking = 3.
                END.
                ELSE DO:
                    IF lRanking <= 4 AND lqValor_D > 0 THEN DO:
                        /* Nivel del Ranking D */
                        lRegsRank = lqValor_D.
                        lRank = IF (p-especial = no) THEN 'D' ELSE 'ND'.
                        lRegCount = 1.
                        lRanking = 4.
                    END.
                    ELSE DO:
                        IF lRanking <= 5 AND lqValor_E > 0 THEN DO:
                            /* Nivel del Ranking E */
                            lRegsRank = lqValor_E.
                            lRank = IF (p-especial = no) THEN 'E' ELSE 'NE'.
                            lRegCount = 1.
                            lRanking = 5.
                        END.
                        ELSE DO:
                            IF lRanking <= 6 AND lqValor_F > 0 THEN DO:
                                /* Nivel del Ranking F */
                                lRegsRank = lqValor_F.
                                lRank = IF ( p-especial = no) THEN 'F' ELSE 'NF'.
                                lRegCount = 1.
                                lRanking = 7.
                            END.
                            ELSE DO:
                                lRegsRank = 99999999.
                                lRank = IF (p-especial = no) THEN 'F' ELSE 'NF'.
                                lRegCount = 1.
                                lRanking = 9.
                            END.
                        END.
                    END.
                END.
            END.
        END.
    END.
    IF lRegsRank > 0 THEN DO:
        IF SUBSTRING(lRank,1,1) = 'N' THEN DO:
            ASSIGN {&tabla}.clasificacion = 'C'.        
        END.
        ELSE ASSIGN {&tabla}.clasificacion = lRank.        
        lRegCount = lRegCount + 1.   /* Incremento contador del ranking */
    END.
    ELSE lRegCount = 999999.

    IF SUBSTRING(lRank,1,1) = 'N' THEN DO:
        ASSIGN {&tabla}.iRanking = 0.
    END.
    ELSE ASSIGN {&tabla}.iRanking = lCount.

    lCount = lCount + 1.
END.
