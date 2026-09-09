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

DEF VAR x-Codigos AS CHAR NO-UNDO.
DEF VAR x-ImpLin AS DEC NO-UNDO.
DEF VAR x-Proveedores AS CHAR NO-UNDO.

IF ( (Faccpedi.coddoc = "COT" AND Faccpedi.TpoPed = "N") OR (Faccpedi.coddoc = "P/M" AND Faccpedi.TpoPed = "CO") )
    AND TODAY <= 04/30/2014 THEN DO:
    x-Codigos = '036047,002688,017892,002735,002687,023296,025555,002854,022648,015989,001629,002794,061655,020036,023285'.
    x-Proveedores = '10031028,52243548,42748137,10008522'.
    x-ImpLin = 0.
    /* NO debe tener otros descuentos */
    FOR EACH Facdpedi OF Faccpedi WHERE (FacDPedi.Por_Dsctos[1] = 0
                                         AND FacDPedi.Por_Dsctos[2] = 0
                                         AND FacDPedi.Por_Dsctos[3] = 0)
        AND Facdpedi.Libre_c05 <> "OF",
        FIRST Almmmatg OF Facdpedi NO-LOCK:
        CASE TRUE:
            WHEN LOOKUP(Facdpedi.codmat, x-Codigos) > 0 THEN x-ImpLin = x-ImpLin + Facdpedi.ImpLin.
            WHEN LOOKUP(Almmmatg.codpr1, x-Proveedores) > 0 THEN x-ImpLin = x-ImpLin + Facdpedi.ImpLin.
        END CASE.
    END.
    IF Faccpedi.CodMon = 2 THEN x-ImpLin = x-ImpLin * Faccpedi.TpoCmb.
    IF x-ImpLin < 250 THEN RETURN.  /* MONTO MINIMO */
    /* REGRABAMOS NUEVOS PORCENTAJES DE DESCUENTO Y RECALCULAMOS IMPORTES */
    FOR EACH Facdpedi OF Faccpedi WHERE (FacDPedi.Por_Dsctos[1] = 0
                                         AND FacDPedi.Por_Dsctos[2] = 0
                                         AND FacDPedi.Por_Dsctos[3] = 0)
        AND Facdpedi.Libre_c05 <> "OF",     /* NO Promociones */
        FIRST Almmmatg OF Facdpedi NO-LOCK:
        IF LOOKUP(Facdpedi.codmat, x-Codigos) > 0 OR
            LOOKUP(Almmmatg.codpr1, x-Proveedores) > 0 THEN DO:
            /* GRABAMOS NUEVOS PORCENTAJES PROMOCIONALES */
            Facdpedi.Libre_c04 = "DCAMPANA".    /* MARCA DE CONTROL */
            Facdpedi.Por_Dsctos[3] = 4.5.
            IF x-ImpLin >= 500 THEN Facdpedi.Por_Dsctos[3] = 6.
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
            IF Facdpedi.AftIsc 
            THEN Facdpedi.ImpIsc = ROUND(Facdpedi.PreBas * Facdpedi.CanPed * (Almmmatg.PorIsc / 100),4).
            ELSE Facdpedi.ImpIsc = 0.
            IF Facdpedi.AftIgv 
            THEN Facdpedi.ImpIgv = Facdpedi.ImpLin - ROUND( Facdpedi.ImpLin  / ( 1 + (s-PorIgv / 100) ), 4 ).
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
         HEIGHT             = 3.81
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


