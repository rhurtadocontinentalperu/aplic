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
         HEIGHT             = 4.42
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

    DEFINE VARIABLE F-IGV AS DECIMAL NO-UNDO.
    DEFINE VARIABLE F-ISC AS DECIMAL NO-UNDO.

    /* RHC 06/03/2015 CALCULO CORREGIDO DE TICKETS UTILEX */
    ASSIGN
        Ccbcdocu.ImpBrt = 0
        Ccbcdocu.ImpDto = 0
        Ccbcdocu.ImpDto2 = 0
        Ccbcdocu.ImpIgv = 0
        Ccbcdocu.ImpIsc = 0
        Ccbcdocu.ImpTot = 0
        Ccbcdocu.ImpExo = 0
        Ccbcdocu.ImpVta = 0
        Ccbcdocu.Libre_d01 = 0  /* Descuento SIN IGV por Encartes y Otros */
        Ccbcdocu.Libre_d02 = 0  /* Descuento por Linea CON IGV */
        f-igv = 0
        f-isc = 0.
    FOR EACH Ccbddocu OF Ccbcdocu NO-LOCK:        
        Ccbcdocu.ImpTot = Ccbcdocu.ImpTot + (Ccbddocu.ImpLin - Ccbddocu.ImpDto2).
        Ccbcdocu.ImpDto2 = Ccbcdocu.ImpDto2 + Ccbddocu.ImpDto2.
        /*Ccbcdocu.Libre_d02 = Ccbcdocu.Libre_d02 + Ccbddocu.ImpDto.*/
        IF Ccbddocu.AftIgv = YES THEN DO:
            f-Igv = f-Igv + (Ccbddocu.ImpLin - Ccbddocu.ImpDto2) / ( 1 + CcbCDocu.PorIgv / 100) * CcbCDocu.PorIgv / 100.
            /*Ccbcdocu.ImpDto = Ccbcdocu.ImpDto + Ccbddocu.ImpDto / ( 1 + CcbCDocu.PorIgv / 100).*/
            Ccbcdocu.Libre_d01 = Ccbcdocu.Libre_d01 + ( Ccbddocu.ImpDto2 / ( 1 + CcbCDocu.PorIgv / 100) ).
        END.
        ELSE DO:
            Ccbcdocu.ImpExo = Ccbcdocu.ImpExo + (Ccbddocu.ImpLin - Ccbddocu.ImpDto2).
            /*Ccbcdocu.ImpDto = Ccbcdocu.ImpDto + Ccbddocu.ImpDto.*/
            Ccbcdocu.Libre_d01 = Ccbcdocu.Libre_d01 + Ccbddocu.ImpDto2.
        END.
    END.
    ASSIGN
        Ccbcdocu.ImpIgv = ROUND(f-Igv, 2)
        Ccbcdocu.ImpDto = ROUND(Ccbcdocu.ImpDto, 2)
        Ccbcdocu.Libre_d01 = ROUND(Ccbcdocu.Libre_d01, 2)
        /*Ccbcdocu.Libre_d02 = ROUND(Ccbcdocu.Libre_d02, 2)*/
        CcbCDocu.ImpVta = IF CcbCDocu.ImpIgv > 0 THEN CcbCDocu.ImpTot - Ccbcdocu.ImpExo - CcbCDocu.ImpIgv ELSE 0.
    ASSIGN
        CcbCDocu.ImpBrt = CcbCDocu.ImpVta + (CcbCDocu.ImpDto + Ccbcdocu.Libre_d01) /*+ CcbCDocu.ImpExo*/.
    IF CcbCDocu.PorIgv = 0.00     /* VENTA INAFECTA */
        THEN ASSIGN
            Ccbcdocu.ImpIgv = 0
            CcbCDocu.ImpVta = CcbCDocu.ImpExo
            CcbCDocu.ImpBrt = CcbCDocu.ImpExo.

    /* ************************************************** */
/* ********************* CALCULO ANTERIOR
    ASSIGN
        Ccbcdocu.ImpDto = 0
        Ccbcdocu.ImpDto2 = 0
        Ccbcdocu.ImpIgv = 0
        Ccbcdocu.ImpIsc = 0
        Ccbcdocu.ImpTot = 0
        Ccbcdocu.ImpExo = 0.
    FOR EACH Ccbddocu OF Ccbcdocu NO-LOCK:        
       F-Igv = F-Igv + Ccbddocu.ImpIgv.
       F-Isc = F-Isc + Ccbddocu.ImpIsc.

       Ccbcdocu.ImpTot = Ccbcdocu.ImpTot + Ccbddocu.ImpLin.
       Ccbcdocu.ImpDto2 = Ccbcdocu.ImpDto2 + Ccbddocu.ImpDto2.

       IF NOT Ccbddocu.AftIgv THEN Ccbcdocu.ImpExo = Ccbcdocu.ImpExo + Ccbddocu.ImpLin.
       IF Ccbddocu.AftIgv = YES
       THEN Ccbcdocu.ImpDto = Ccbcdocu.ImpDto + ROUND(Ccbddocu.ImpDto / (1 + Ccbcdocu.PorIgv / 100), 2).
       ELSE Ccbcdocu.ImpDto = Ccbcdocu.ImpDto + Ccbddocu.ImpDto.
    END.
    ASSIGN
        Ccbcdocu.ImpIgv = ROUND(F-IGV,2)
        Ccbcdocu.ImpIsc = ROUND(F-ISC,2).
    /* ****************************************************************** */
    ASSIGN
        Ccbcdocu.ImpTot = Ccbcdocu.ImpTot - Ccbcdocu.ImpDto2
        Ccbcdocu.ImpIgv = Ccbcdocu.ImpIgv - ROUND( Ccbcdocu.ImpDto2 / (1 + Ccbcdocu.PorIgv / 100) * Ccbcdocu.PorIgv / 100, 2).
    ASSIGN
        Ccbcdocu.ImpVta = Ccbcdocu.ImpTot - Ccbcdocu.ImpExo - Ccbcdocu.ImpIgv.
    ASSIGN
        Ccbcdocu.ImpBrt = Ccbcdocu.ImpVta /*+ Ccbcdocu.ImpIsc*/ + Ccbcdocu.ImpDto /*+ Ccbcdocu.ImpExo*/
        /*Ccbcdocu.SdoAct  = Ccbcdocu.ImpTot.*/.

    /* APLICAMOS EL IMPORTE POR FACTURA POR ADELANTOS */
/*     ASSIGN                                                    */
/*         Ccbcdocu.SdoAct = Ccbcdocu.SdoAct - Ccbcdocu.ImpTot2. */

  /* CALCULO DE PERCEPCIONES */
  RUN vta2/calcula-percepcion-contado ( ROWID(Ccbcdocu), ROWID(B-CPEDM) ).
  FIND CURRENT CcbCDocu.
  /* *********************** */

**************************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


