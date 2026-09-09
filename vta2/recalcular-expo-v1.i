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

DEFINE VARIABLE S-UNDVTA AS CHAR NO-UNDO.
DEFINE VARIABLE F-FACTOR AS DECI NO-UNDO.
DEFINE VARIABLE F-PREBAS LIKE Almmmatg.PreBas NO-UNDO.
DEFINE VARIABLE F-DSCTOS LIKE Almmmatg.PorMax NO-UNDO.
DEFINE VARIABLE X-CANPED AS DECI NO-UNDO.
DEFINE VARIABLE F-PREVTA AS DECI NO-UNDO.
DEFINE VARIABLE Y-DSCTOS AS DECI NO-UNDO.
DEFINE VARIABLE Z-DSCTOS AS DECI NO-UNDO.
DEFINE VARIABLE x-TipDto AS CHAR NO-UNDO.
DEFINE VARIABLE f-FleteUnitario AS DEC DECIMALS 6 NO-UNDO.

SESSION:SET-WAIT-STATE('GENERAL').
ACTUALIZACION:
FOR EACH ITEM WHERE ITEM.Libre_c05 <> "OF", FIRST Almmmatg OF ITEM NO-LOCK, FIRST Almsfami OF Almmmatg NO-LOCK:
    ASSIGN
        F-FACTOR = ITEM.Factor
        x-CanPed = ITEM.CanPed
        s-UndVta = ITEM.UndVta
        f-PreVta = ITEM.PreUni
        f-PreBas = ITEM.PreBas
        f-Dsctos = ITEM.PorDto
        z-Dsctos = ITEM.Por_Dsctos[2]
        y-Dsctos = ITEM.Por_Dsctos[3].
    RUN vta2/precio-de-venta-eventos (
        s-TpoPed,
        pCodDiv,
        s-CodCli,
        s-CodMon,
        INPUT-OUTPUT s-UndVta,
        OUTPUT f-Factor,
        Almmmatg.CodMat,
        s-FmaPgo,
        x-CanPed,
        s-NroDec,
        OUTPUT f-PreBas,
        OUTPUT f-PreVta,
        OUTPUT f-Dsctos,
        OUTPUT y-Dsctos,
        OUTPUT x-TipDto,
        "",
        OUTPUT f-FleteUnitario,
        TRUE
        ).
    
/*         &IF DEFINED(pTpoPed) &THEN         */
/*         RUN vta2/PrecioMayorista-Cred-v2 ( */
/*             {&pTpoPed},                    */
/*             pCodDiv,                       */
/*             s-CodCli,                      */
/*             s-CodMon,                      */
/*             INPUT-OUTPUT s-UndVta,         */
/*             OUTPUT f-Factor,               */
/*             Almmmatg.CodMat,               */
/*             s-FmaPgo,                      */
/*             x-CanPed,                      */
/*             s-NroDec,                      */
/*             OUTPUT f-PreBas,               */
/*             OUTPUT f-PreVta,               */
/*             OUTPUT f-Dsctos,               */
/*             OUTPUT y-Dsctos,               */
/*             OUTPUT z-Dsctos,               */
/*             OUTPUT x-TipDto,               */
/*             OUTPUT f-FleteUnitario,        */
/*             ITEM.TipVta,                   */
/*             YES                            */
/*             ).                             */
/*         &ELSE                              */
/*         RUN vta2/PrecioMayorista-Cred-v2 ( */
/*             s-TpoPed,                      */
/*             pCodDiv,                       */
/*             s-CodCli,                      */
/*             s-CodMon,                      */
/*             INPUT-OUTPUT s-UndVta,         */
/*             OUTPUT f-Factor,               */
/*             Almmmatg.CodMat,               */
/*             s-FmaPgo,                      */
/*             x-CanPed,                      */
/*             s-NroDec,                      */
/*             OUTPUT f-PreBas,               */
/*             OUTPUT f-PreVta,               */
/*             OUTPUT f-Dsctos,               */
/*             OUTPUT y-Dsctos,               */
/*             OUTPUT z-Dsctos,               */
/*             OUTPUT x-TipDto,               */
/*             OUTPUT f-FleteUnitario,        */
/*             ITEM.TipVta,                   */
/*             YES                            */
/*             ).                             */
/*         &ENDIF                             */
        IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
            DELETE ITEM.
            NEXT ACTUALIZACION.
        END.
    ASSIGN 
        ITEM.Factor = f-Factor
        ITEM.UndVta = s-UndVta
        ITEM.PreUni = F-PREVTA
        ITEM.Libre_d02 = f-FleteUnitario    /* Flete Unitario */
        ITEM.PreBas = F-PreBas 
        ITEM.PreVta[1] = F-PreVta   /* CONTROL DE PRECIO DE LISTA */
        ITEM.PorDto = F-DSCTOS      /* Ambos descuentos afectan */
        ITEM.PorDto2 = 0            /* el precio unitario */
        ITEM.Por_Dsctos[2] = z-Dsctos
        ITEM.Por_Dsctos[3] = Y-DSCTOS 
        ITEM.AftIgv = (IF s-FmaPgo = '900' THEN NO ELSE Almmmatg.AftIgv)
        ITEM.AftIsc = Almmmatg.AftIsc
        ITEM.ImpIsc = 0
        ITEM.ImpIgv = 0
        ITEM.Libre_c04 = x-TipDto.
    ASSIGN
        ITEM.ImpLin = ROUND ( ITEM.CanPed * ITEM.PreUni * 
                    ( 1 - ITEM.Por_Dsctos[1] / 100 ) *
                    ( 1 - ITEM.Por_Dsctos[2] / 100 ) *
                    ( 1 - ITEM.Por_Dsctos[3] / 100 ), 2 ).
    IF ITEM.Por_Dsctos[1] = 0 AND ITEM.Por_Dsctos[2] = 0 AND ITEM.Por_Dsctos[3] = 0 
        THEN ITEM.ImpDto = 0.
    ELSE ITEM.ImpDto = ITEM.CanPed * ITEM.PreUni - ITEM.ImpLin.
    /* RHC 04/08/2015 Si existe f-FleteUnitario se recalcula el Descuento */
    IF f-FleteUnitario > 0 THEN DO:
      /* El flete afecta el monto final */
      IF ITEM.ImpDto = 0 THEN DO:       /* NO tiene ningun descuento */
          ASSIGN
              ITEM.PreUni = ROUND(f-PreVta + f-FleteUnitario, s-NroDec)  /* Incrementamos el PreUni */
              ITEM.ImpLin = ITEM.CanPed * ITEM.PreUni.
      END.
      ELSE DO:      /* CON descuento promocional o volumen */
          ASSIGN
              ITEM.ImpLin = ITEM.ImpLin + (ITEM.CanPed * f-FleteUnitario)
              ITEM.PreUni = ROUND( (ITEM.ImpLin + ITEM.ImpDto) / ITEM.CanPed, s-NroDec).
      END.
    END.
    /* ***************************************************************** */
    ASSIGN
        ITEM.ImpLin = ROUND(ITEM.ImpLin, 2)
        ITEM.ImpDto = ROUND(ITEM.ImpDto, 2).
    IF ITEM.AftIsc THEN 
        ITEM.ImpIsc = ROUND(ITEM.PreBas * ITEM.CanPed * (Almmmatg.PorIsc / 100),4).
    ELSE ITEM.ImpIsc = 0.
    IF ITEM.AftIgv THEN  
        ITEM.ImpIgv = ITEM.ImpLin - ROUND(ITEM.ImpLin  / (1 + (s-PorIgv / 100)),4).
    ELSE ITEM.ImpIgv = 0.

    /* RHC 07/11/2013 CALCULO DE PERCEPCION */
    DEF VAR s-PorPercepcion AS DEC INIT 0 NO-UNDO.
    ASSIGN
        ITEM.CanSol = 0
        ITEM.CanApr = 0.
    FIND FIRST Vtatabla WHERE Vtatabla.codcia = s-codcia
        AND Vtatabla.tabla = 'CLNOPER'
        AND VtaTabla.Llave_c1 = s-CodCli
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Vtatabla THEN DO:
        FIND gn-clie WHERE gn-clie.codcia = cl-codcia AND gn-clie.codcli = s-codcli NO-LOCK NO-ERROR.
        IF AVAILABLE gn-clie THEN DO:
            IF gn-clie.Libre_L01 = YES AND gn-clie.RucOld <> "SI" THEN s-Porpercepcion = 0.5.
            IF gn-clie.Libre_L01 = NO AND gn-clie.RucOld <> "SI" THEN s-Porpercepcion = 2.
        END.
        /* Ic 04 Julio 2013 
            gn-clie.Libre_L01   : PERCEPCTOR
            gn-clie.RucOld      : RETENEDOR
        */
        IF s-Cmpbnte = "BOL" THEN s-Porpercepcion = 2.
        IF Almsfami.Libre_c05 = "SI" THEN
            ASSIGN
            ITEM.CanSol = s-PorPercepcion
            ITEM.CanApr = ROUND(ITEM.implin * s-PorPercepcion / 100, 2).
    END.
    /* ************************************ */
END.
SESSION:SET-WAIT-STATE('').

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
         HEIGHT             = 4.19
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


