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

DEF VAR j AS INT NO-UNDO.
DEF VAR x-Canti AS DEC NO-UNDO.
DEF VAR x-Rango AS DEC NO-UNDO.
DEF VAR x-DctoxVolumen AS DECIMAL DECIMALS 4 NO-UNDO.
DEF VAR F-PREBAS AS DEC DECIMALS 4 NO-UNDO.
DEF VAR F-PREVTA AS DEC DECIMALS 4 NO-UNDO.
DEF VAR Y-DSCTOS AS DEC NO-UNDO.                /* Descuento por Volumen y/o Promocional */
DEF VAR X-TIPDTO AS CHAR NO-UNDO.               /* Tipo de descuento aplicado (PROM, VOL) */ 
DEF VAR F-FACTOR AS DECI NO-UNDO.
DEF VAR F-DSCTOS LIKE Almmmatg.PorMax NO-UNDO.

/* Variables para definir la lista de precios */
EMPTY TEMP-TABLE ResumenxLinea.
EMPTY TEMP-TABLE ErroresxLinea.

FOR EACH facdpedi OF Faccpedi NO-LOCK WHERE Facdpedi.Libre_c05 <> "OF",
    FIRST Almmmatg OF Facdpedi NO-LOCK,
    FIRST Almsfami OF Almmmatg NO-LOCK,
    FIRST FacTabla NO-LOCK WHERE FacTabla.codcia = s-codcia
        AND FacTabla.Tabla = "DVXDSF"
        AND FacTabla.Codigo = TRIM(s-CodDiv) + '|' + TRIM(Almsfami.codfam) + '|' + TRIM(Almsfami.subfam)
        AND FacTabla.Nombre <> "":
    /* Transformamos la cantidad en unidad base a cantidad en unidad de dcto x volumen */
    FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas
        AND Almtconv.Codalter = FacTabla.Nombre
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almtconv THEN DO:
        MESSAGE 'NO está configurado el factor de equivalencia para el producto' Almmmatg.codmat SKIP
            '        Unidad Base:' Almmmatg.UndBas SKIP
            'Unidad de Sub-Linea:' FacTabla.Nombre SKIP(1)
            'SE CONTINUARÁ CON OTRO ARTÍCULO' SKIP(2)
            '*** Avisar a Sistemas ***'
            VIEW-AS ALERT-BOX WARNING TITLE "DESCUENTO POR VOLUMEN POR LINEA".
        FIND FIRST ErroresxLinea WHERE ErroresxLinea.codfam = Almmmatg.codfam
            AND ErroresxLinea.subfam = Almmmatg.subfam NO-ERROR.
        IF NOT AVAILABLE ErroresxLinea THEN CREATE ErroresxLinea.
        ASSIGN
            ErroresxLinea.codfam = Almmmatg.codfam
            ErroresxLinea.subfam = Almmmatg.subfam.
        NEXT.
    END.
    ASSIGN
        F-FACTOR = Almtconv.Equival.
    /* ******************************************************************************* */
    FIND FIRST ResumenxLinea WHERE ResumenxLinea.codfam = Almmmatg.codfam
        AND ResumenxLinea.subfam = Almmmatg.subfam NO-ERROR.
    IF NOT AVAILABLE ResumenxLinea THEN CREATE ResumenxLinea.
    ASSIGN
        ResumenxLinea.codfam = Almmmatg.codfam
        ResumenxLinea.subfam = Almmmatg.subfam
        ResumenxLinea.canped = ResumenxLinea.canped + (facdpedi.canped * facdpedi.factor / f-Factor).
END.
/* Eliminamos las lineas con errores */
FOR EACH ErroresxLinea:
    FIND ResumenxLinea WHERE ResumenxLinea.codfam = ErroresxLinea.codfam
        AND ResumenxLinea.subfam = ErroresxLinea.subfam
        NO-ERROR.
    IF AVAILABLE ResumenxLinea THEN DELETE ResumenxLinea.
END.

FOR EACH ResumenxLinea, 
    FIRST Almsfami NO-LOCK WHERE Almsfami.codcia = s-codcia
        AND Almsfami.codfam = ResumenxLinea.codfam
        AND Almsfami.subfam = ResumenxLinea.subfam,
    FIRST FacTabla NO-LOCK WHERE FacTabla.codcia = s-codcia
        AND FacTabla.Tabla = "DVXDSF"
        AND FacTabla.Codigo = TRIM(s-CodDiv) + '|' + TRIM(Almsfami.codfam) + '|' + TRIM(Almsfami.subfam):
    ASSIGN
        x-DctoxVolumen = 0
        x-Rango = 0
        X-CANTI = ResumenxLinea.canped.
    DO J = 1 TO 10:
        IF X-CANTI >= FacTabla.Valor[j] AND FacTabla.Valor[j + 10] > 0  THEN DO:
            IF X-RANGO  = 0 THEN X-RANGO = FacTabla.Valor[j].
            IF X-RANGO <= FacTabla.Valor[j] THEN DO:
                ASSIGN
                    X-RANGO  = FacTabla.Valor[j]
                    x-DctoxVolumen = FacTabla.Valor[j + 10].
            END.   
        END.   
    END.
    /* ********************************************************** */
    IF x-DctoxVolumen > 0 THEN DO:
        FOR EACH Facdpedi OF Faccpedi WHERE Facdpedi.Libre_c05 <> "OF", 
            FIRST Almmmatg OF Facdpedi NO-LOCK WHERE Almmmatg.codfam = ResumenxLinea.codfam 
                AND Almmmatg.subfam = ResumenxLinea.subfam:
            /* Recalculamos todos los Items */
            RUN PrecioUnitarioContadoMayorista (
                s-CodCia,
                s-CodDiv,
                s-CodCli,
                s-CodMon,
                s-TpoCmb,
                OUTPUT f-Factor,
                Facdpedi.codmat,
                s-FlgSit,
                Facdpedi.undvta,
                Facdpedi.CanPed,
                s-NroDec,
                Facdpedi.almdes,
                OUTPUT f-PreBas,
                OUTPUT f-PreVta,
                OUTPUT f-Dsctos,
                OUTPUT y-Dsctos,
                OUTPUT x-TipDto
                ).
            IF RETURN-VALUE <> 'ADM-ERROR' THEN DO:
                ASSIGN
                    Facdpedi.PreUni = F-PREVTA
                    Facdpedi.PreBas = F-PREBAS.
            END.
            ASSIGN
                Y-DSCTOS = x-DctoxVolumen          /* OJO */
                X-TIPDTO = "DVXDSF".
            ASSIGN 
                Facdpedi.PorDto  = 0
                Facdpedi.PorDto2 = 0            /* el precio unitario */
                Facdpedi.Por_Dsctos[1] = 0
                Facdpedi.Por_Dsctos[2] = 0
                Facdpedi.Por_Dsctos[3] = Y-DSCTOS 
                Facdpedi.ImpIsc = 0
                Facdpedi.ImpIgv = 0
                Facdpedi.Libre_c04 = x-TipDto.
            ASSIGN
                Facdpedi.ImpLin = ROUND ( Facdpedi.CanPed * Facdpedi.PreUni * 
                            ( 1 - Facdpedi.Por_Dsctos[1] / 100 ) *
                            ( 1 - Facdpedi.Por_Dsctos[2] / 100 ) *
                            ( 1 - Facdpedi.Por_Dsctos[3] / 100 ), 2 ).
            IF Facdpedi.Por_Dsctos[1] = 0 AND Facdpedi.Por_Dsctos[2] = 0 AND Facdpedi.Por_Dsctos[3] = 0 
                THEN Facdpedi.ImpDto = 0.
            ELSE Facdpedi.ImpDto = Facdpedi.CanPed * Facdpedi.PreUni - Facdpedi.ImpLin.
            ASSIGN
                Facdpedi.ImpLin = ROUND(Facdpedi.ImpLin, 2)
                Facdpedi.ImpDto = ROUND(Facdpedi.ImpDto, 2).
            IF Facdpedi.AftIsc THEN 
                Facdpedi.ImpIsc = ROUND(Facdpedi.PreBas * Facdpedi.CanPed * (Almmmatg.PorIsc / 100),4).
            ELSE Facdpedi.ImpIsc = 0.
            IF Facdpedi.AftIgv THEN  
                Facdpedi.ImpIgv = Facdpedi.ImpLin - ROUND(Facdpedi.ImpLin  / (1 + (s-PorIgv / 100)),4).
            ELSE Facdpedi.ImpIgv = 0.
        END.
    END.
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
         HEIGHT             = 4.12
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


