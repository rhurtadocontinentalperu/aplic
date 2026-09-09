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

/* ************************************************************* */
/* RHC 21/01/2016 Descuento adicional a todos los descuentos     */
/* Debemos ejecutaro al final final */

/* Filtros */
RETURN.
IF Faccpedi.fchped > DATE(03,31,2016) THEN RETURN.  /* Hasta el 31 de Marzo 2016 */
FIND gn-divi WHERE gn-divi.codcia = s-codcia
    AND gn-divi.coddiv = Faccpedi.coddiv
    NO-LOCK NO-ERROR.
/* Solo tiendas y venta horizontal */
IF NOT AVAILABLE gn-divi OR LOOKUP(gn-divi.canalventa, 'TDA,HOR') = 0 THEN RETURN.
/* No Supermercados, Contrato Marco, Expolibreria ni Remates */
IF LOOKUP(Faccpedi.TpoPed, 'S,M,E,R') > 0 THEN RETURN.
/* Fin de filtros */

/* 1ro ACUMULAMOS Solo linea 010 sublinea 012 y subtipo Licencias (002) */
DEF VAR x-Cantidad AS DEC INIT 0 NO-UNDO.
&SCOPED-DEFINE Filtrado Almmmatg.codfam = '010' ~
    AND Almmmatg.subfam = '012' ~
    AND LOOKUP(Almmmatg.libre_c01, '002,004') > 0

FOR EACH Facdpedi OF Faccpedi,
    FIRST Almmmatg OF Facdpedi NO-LOCK WHERE {&Filtrado}:
    x-Cantidad = x-Cantidad + (Facdpedi.CanPed * Facdpedi.Factor).
    /* Quitamos el 1% si ya tiene uno guardado */
    Facdpedi.Por_Dsctos[2] = 0 .
END.
/* 2do. Aplicamos 1% de descuento si es >= a 500 Unidades */
IF x-Cantidad >= 500 THEN DO:
    FOR EACH Facdpedi OF Faccpedi,
        FIRST Almmmatg OF Facdpedi NO-LOCK WHERE {&Filtrado}:
        /* Normalmente el [2] se usa para dctos especiales por evento (No activo) */
        ASSIGN 
            Facdpedi.Por_Dsctos[2] = 1  /* OJO: incrementamos 1% */
            Facdpedi.ImpIsc = 0
            Facdpedi.ImpIgv = 0
            Facdpedi.Libre_c04 = "010|012|002". /* Linea Sublina Subtipo */
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
         HEIGHT             = 4.73
         WIDTH              = 49.29.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


