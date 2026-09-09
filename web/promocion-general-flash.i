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

/* Limpiamos promociones */
i-nItem = 0.
FOR EACH ITEM NO-LOCK:
    i-nItem = i-nItem + 1.
END.
/* Si Vtactabla.Libre_c04 = "AND" y NO hay promociones con precio unitario => se graba automaticamente */
IF Vtactabla.Libre_c04 = "AND" AND NOT CAN-FIND(FIRST Promocion WHERE Promocion.Libre_d03 > 0 NO-LOCK)
    THEN DO:
    FOR EACH Promocion:
        Promocion.Libre_d04 = Promocion.Libre_d05.  /* Se regala todo */
    END.
END.
ELSE DO:
    /* Puede que solo se pueda llevar una de las promociones o tal vez quiera comprar una de las promociones */
    FOR EACH Promocion:
        Promocion.Libre_d04 = Promocion.Libre_d05.  /* Se regala todo */
    END.
    /* Pantalla general de promociones */
    IF s-CodDoc <> "COT" THEN DO:
        /* *********************************************************************************************** */
        /* 25/07/2023: En caso de ser una regalo ALEATORIO */
        /* *********************************************************************************************** */
        CASE TRUE:
            WHEN Vtactabla.Libre_L05 = YES AND Vtactabla.Libre_c04 = "OR" THEN DO:
                /* **************************************************************** */
                /* Buscamos stock disponible */
                /* **************************************************************** */
                FOR EACH Promocion:
                    x-StkAct = 0.
                    FIND Almmmate WHERE Almmmate.codcia = s-codcia
                        AND Almmmate.codalm = pCodAlm
                        AND Almmmate.codmat = Promocion.LlaveDetalle
                        NO-LOCK NO-ERROR.
                    IF AVAILABLE Almmmate THEN x-StkAct = Almmmate.StkAct.
                    IF x-StkAct > 0 THEN DO:
                        RUN gn/Stock-Comprometido-v2 (Promocion.LlaveDetalle, pCodAlm, YES, OUTPUT s-StkComprometido).
                        /* **************************************************************** */
                        /* OJO: Cuando se modifica hay que actualizar el STOCK COMPROMETIDO */
                        /* **************************************************************** */
                        IF pEvento = "UPDATE" THEN DO:
                            FIND FIRST ITEM.
                            FIND FIRST Facdpedi WHERE Facdpedi.codcia = ITEM.codcia AND
                                Facdpedi.coddoc = ITEM.coddoc AND
                                Facdpedi.nroped = ITEM.nroped AND
                                Facdpedi.codmat = Promocion.LlaveDetalle
                                NO-LOCK NO-ERROR.
                            IF AVAILABLE Facdpedi THEN s-StkComprometido = s-StkComprometido - (Facdpedi.canped * Facdpedi.factor).
                        END.
                    END.
                    s-StkDis = x-StkAct - s-StkComprometido.
                    IF s-StkDis <= 0 OR Promocion.Libre_d04 > s-StkDis THEN DELETE Promocion.
                END.
                x-Registros = 0.
                x-Elegido = 0.
                FOR EACH Promocion:
                    x-Registros = x-Registros + 1.
                END.
                IF x-Registros = 0 THEN RETURN "OK".
                IF x-Registros > 1 THEN DO:
                    /* Escogemos 1 al azar */
                    x-Elegido = RANDOM(1, x-Registros).
                    x-Registros = 0.
                    FOR EACH Promocion:
                        x-Registros = x-Registros + 1.
                        IF x-Registros <> x-Elegido THEN DELETE Promocion.
                    END.
                END.
            END.
            OTHERWISE DO:
                /* SIEMPRE YES */
                DEF VAR pRpta AS LOG NO-UNDO.
                RUN vta2/dpromociongeneral (VtaCTabla.Tabla, VtaCTabla.Llave, Vtactabla.Libre_c04, OUTPUT pRpta, INPUT-OUTPUT TABLE Promocion).
                IF pRpta = NO THEN RETURN "OK" .    /*RETURN "ADM-ERROR".*/
                
            END.
        END CASE.
    END.
END.
/* RHC 14/05/2014 NUEVO CASO: Promociones que EXCLUYEN ENCARTES */
FIND FIRST Promocion NO-LOCK NO-ERROR.
IF VtaCTabla.Libre_L01 = YES AND AVAILABLE Promocion THEN pError = "**EXCLUYENTE**".
/* Grabamos las Promociones */
IF CAN-FIND(FIRST Promocion WHERE Promocion.Libre_d04 > 0 NO-LOCK) THEN DO:
    /* Marcamos los items que SI están afectos a la promocion */
    FOR EACH ITEM:
        IF NOT CAN-FIND(FIRST Detalle WHERE Detalle.codmat = ITEM.codmat NO-LOCK) 
            THEN ASSIGN 
                    ITEM.Libre_c02 = "PROM" + '|' + VtaCTabla.Llave + '|' + STRING(Promocion.Libre_d05) + 
                    '|' + STRING(Promocion.Libre_d04).
                    /*ITEM.Libre_d02 = Promocion.Libre_d04 / Promocion.Libre_d05. /* Factor */*/
    END.
END.

FOR EACH Promocion NO-LOCK WHERE Promocion.Libre_d04 > 0,
    FIRST Almmmatg NO-LOCK WHERE Almmmatg.codcia = Promocion.codcia
    AND Almmmatg.codmat = Promocion.LlaveDetalle:
    /* ********************** CONSISTENCIAS ******************* */
    /* NO SE PUEDE REPETIR EL CODIGO PROMOCIONAL */
    /* ******************************************************** */
    FIND FIRST ITEM WHERE ITEM.codmat = Almmmatg.CodMat NO-LOCK NO-ERROR.
    IF AVAILABLE ITEM THEN DO:
        /* ************************************************************************************************ */
        /* 25/07/2022: CCamus Se incrementa a lo vendido siempre y cuando sea un regalo (100% de descuento) */
        IF NOT ( ITEM.Libre_c05 <> "OF" AND Promocion.Libre_d03 = 0 ) THEN NEXT.
        /* ************************************************************************************************ */
        ASSIGN
            ITEM.CanPed = ITEM.CanPed + (Promocion.Libre_d04 / ITEM.Factor).
        ASSIGN
            ITEM.Por_Dsctos[1] = 1 - ( (ITEM.ImpLin) / (ITEM.CanPed * ITEM.PreUni) / (1 - ITEM.Por_Dsctos[2] / 100) / (1 - ITEM.Por_Dsctos[3] / 100) ).
        ASSIGN
            ITEM.Por_Dsctos[1] = ITEM.Por_Dsctos[1] * 100.

        /* *********************** */
        /* 08/09/2022 Efecto SUNAT */
        /* *********************** */
        &IF {&ARITMETICA-SUNAT} &THEN
            /*
            MESSAGE "ITEM.cImporteTotalConImpuesto " ITEM.cImporteTotalConImpuesto SKIP
                    "ITEM.Por_Dsctos[2] " ITEM.Por_Dsctos[2] SKIP
                    "ITEM.Por_Dsctos[3] " ITEM.Por_Dsctos[3] SKIP
                    "ITEM.CanPed " ITEM.CanPed SKIP
                    "ITEM.PreUni " ITEM.PreUni.
            */
            /*ITEM.Por_Dsctos[1] = ROUND((1 - ( (ITEM.cImporteTotalConImpuesto) / (ITEM.CanPed * ITEM.PreUni) / (1 - ITEM.Por_Dsctos[2] / 100) / (1 - ITEM.Por_Dsctos[3] / 100) )) * 100, 6).*/
            ITEM.Por_Dsctos[1] = ROUND((1 - ( (ITEM.ImpLin) / (ITEM.CanPed * ITEM.PreUni) / (1 - ITEM.Por_Dsctos[2] / 100) / (1 - ITEM.Por_Dsctos[3] / 100) )) * 100, 6).
        &ENDIF
        /* *********************** */
        {vta2/calcula-linea-detalle.i &Tabla="ITEM"}
        ASSIGN
            ITEM.Libre_d03 = ITEM.Libre_d03 + (Promocion.Libre_d04 / ITEM.Factor).   /* OJO: Control */
        NEXT.
    END.
    /* INSCRITO EN EL ALMACEN */
    IF s-CodDoc <> "COT" THEN DO:
        FIND Almmmate WHERE Almmmate.codcia = s-CodCia
            AND Almmmate.codalm = p-CodAlm
            AND Almmmate.codmat = Promocion.LlaveDetalle
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Almmmate THEN DO:
            pError = 'Producto promocional ' + Almmmatg.CodMat + ' ' + Almmmatg.desmat + CHR(10) +
                'NO asignado al almacén ' + p-CodAlm.
            UNDO, RETURN 'ADM-ERROR'.
        END.
    END.
    /* ******************************************************** */
    /* GRABAMOS EL REGISTRO */
    I-NITEM = I-NITEM + 1.
    CREATE ITEM.
    ASSIGN
        ITEM.CodCia = s-CodCia
        ITEM.CodDiv = pCodDiv
        ITEM.coddoc = s-coddoc
        ITEM.NroItm = I-NITEM
        ITEM.almdes = p-CodAlm
        ITEM.codmat = Almmmatg.codmat
        ITEM.canped = Promocion.Libre_d04
        ITEM.CanPick = ITEM.CanPed      /* OJO */
        ITEM.aftigv = Almmmatg.AftIgv
        ITEM.aftisc = Almmmatg.AftIsc.
    /* Hay 2 casos: Con Precio Unitario (Promocion.Libre_d03 > 0) o Sin Precio Unitario (Promocion.Libre_d03 = 0)
    */
    /* Buscamos el precio unitario referencial */
    RUN {&precio-venta-general} (
        s-TpoPed,
        pCodDiv,
        s-CodCli,
        s-CodMon,
        INPUT-OUTPUT s-UndVta,
        OUTPUT f-Factor,
        Almmmatg.CodMat,
        s-FmaPgo,
        ITEM.CanPed,
        s-NroDec,
        OUTPUT f-PreBas,
        OUTPUT f-PreVta,
        OUTPUT f-Dsctos,
        OUTPUT y-Dsctos,
        OUTPUT z-Dsctos,
        OUTPUT x-TipDto,
        "",     /* ClfCli: lo ingresamos solo si se quiere forzar la clasificacion */
        OUTPUT x-Flete,
        "",
        FALSE,
        OUTPUT pMensaje).

    /*MESSAGE "Promocion.Libre_d03XXXXXXX " Promocion.Libre_d03.*/

    IF Promocion.Libre_d03 = 0 THEN DO:
        ASSIGN
            f-Dsctos = 0
            z-Dsctos = 0
            y-Dsctos = 100.     /* 100% de Descuento */
    END.
    ELSE DO:
        ASSIGN
            f-PreBas = Promocion.Libre_d03
            f-PreVta = Promocion.Libre_d03
            f-Dsctos = 0
            z-Dsctos = 0
            y-Dsctos = 0.
    END.
    ASSIGN
        ITEM.undvta = s-undvta
        ITEM.factor = f-factor
        ITEM.PorDto = f-Dsctos
        ITEM.PreBas = f-PreBas
        ITEM.PreUni = f-PreVta
        ITEM.Libre_c04 = x-TipDto
        ITEM.Libre_c05 = 'OF'          /* Marca de PROMOCION */
        ITEM.Por_Dsctos[2] = y-Dsctos
        ITEM.Por_Dsctos[3] = z-Dsctos.
    ASSIGN
        ITEM.ImpLin = ITEM.CanPed * ITEM.PreUni * 
                      ( 1 - ITEM.Por_Dsctos[1] / 100 ) *
                      ( 1 - ITEM.Por_Dsctos[2] / 100 ) *
                      ( 1 - ITEM.Por_Dsctos[3] / 100 ).
    IF ITEM.Por_Dsctos[1] = 0 AND ITEM.Por_Dsctos[2] = 0 AND ITEM.Por_Dsctos[3] = 0 
        THEN ITEM.ImpDto = 0.
        ELSE ITEM.ImpDto = ITEM.CanPed * ITEM.PreUni - ITEM.ImpLin.
    IF ITEM.AftIsc 
        THEN ITEM.ImpIsc = ROUND(ITEM.PreBas * ITEM.CanPed * (Almmmatg.PorIsc / 100),4).
    ELSE ITEM.ImpIsc = 0.
    IF ITEM.AftIgv 
        THEN ITEM.ImpIgv = ITEM.ImpLin - ROUND( ITEM.ImpLin  / ( 1 + (s-PorIgv / 100) ), 4 ).
    ELSE ITEM.ImpIgv = 0.
END.

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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


