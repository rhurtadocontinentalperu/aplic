&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : 
    Purpose     : Genereción de comprobantes de Percepción

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEF INPUT PARAMETER pRowid AS ROWID.

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR cl-codcia AS INT.
DEF SHARED VAR s-user-id AS CHAR.
DEF VAR ImpMinPercep AS DEC INIT 1500 NO-UNDO.

FIND Faccpedi WHERE ROWID(Faccpedi) = pRowid EXCLUSIVE-LOCK NO-ERROR.
IF NOT AVAILABLE Faccpedi THEN RETURN "ADM-ERROR".

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
         HEIGHT             = 4.27
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

DEF VAR s-PorPercepcion AS DEC NO-UNDO.
DEF VAR pPercepcion AS DEC NO-UNDO.
DEF VAR f-ImpPercepcion AS DEC NO-UNDO.
DEF VAR f-LinPercepcion AS DEC NO-UNDO.

DEF VAR FILL-IN-items AS INT NO-UNDO.
DEF VAR iCountItem AS INT NO-UNDO.

FIND FacCfgGn WHERE FacCfgGn.CodCia = s-CodCia NO-LOCK NO-ERROR.
FILL-IN-items = 999.
IF FacCPedi.Cmpbnte = 'BOL' THEN FILL-IN-items = FacCfgGn.Items_Boleta.
IF FacCPedi.Cmpbnte = 'FAC' THEN FILL-IN-items = FacCfgGn.Items_Factura.

/* Veamos si es sujeto a Percepcion */
f-ImpPercepcion = 0.
FOR EACH Facdpedi OF Faccpedi NO-LOCK,
    FIRST Almmmatg OF Facdpedi NO-LOCK,
    FIRST Almsfami OF Almmmatg NO-LOCK WHERE Almsfami.Libre_C05 = "SI":
    f-ImpPercepcion = f-ImpPercepcion + Facdpedi.ImpLin.
END.

/* NOTA: En caso de COTIZACIONES (COT y C/M) TODO tiene percepción */
IF LOOKUP(Faccpedi.coddoc, 'COT,C/M') > 0 THEN DO:
    FILL-IN-Items = 999.        /* Sin límite de items */
    f-ImpPercepcion = 999999999.  /* */
END.
/* *************************************************************** */
ASSIGN
    s-Porpercepcion = 0
    pPercepcion = 0.
/*MESSAGE faccpedi.coddoc faccpedi.nroped faccpedi.codref faccpedi.cmpbnte f-imppercepcion.*/
PERCEPCION:
DO:
    ASSIGN
        Faccpedi.AcuBon[4] = 0
        Faccpedi.AcuBon[5] = 0.
    /* Considerar para los TICKETS factura Ic 04 Jul 2013 */
    IF (FacCPedi.Cmpbnte = "BOL")  THEN DO:
        IF Faccpedi.codmon = 1 AND f-ImpPercepcion <= ImpMinPercep THEN LEAVE PERCEPCION.
        IF Faccpedi.codmon = 2 AND f-ImpPercepcion * Faccpedi.tpocmb <= ImpMinPercep THEN LEAVE PERCEPCION.
    END.

    IF (FacCPedi.Cmpbnte = "TCK" AND FacCPedi.Libre_C04 <> 'FAC')  THEN DO:
       IF Faccpedi.codmon = 1 AND f-ImpPercepcion <= ImpMinPercep THEN LEAVE PERCEPCION.
        IF Faccpedi.codmon = 2 AND f-ImpPercepcion * Faccpedi.tpocmb <= ImpMinPercep THEN LEAVE PERCEPCION.
    END.
    /*  -----------------------------   */
    FIND FIRST Vtatabla WHERE Vtatabla.codcia = s-codcia
        AND Vtatabla.tabla = 'CLNOPER'
        AND VtaTabla.Llave_c1 = Faccpedi.RucCli
        NO-LOCK NO-ERROR.
    IF AVAILABLE Vtatabla THEN LEAVE PERCEPCION.
    /* ******************************** */
    FIND gn-clie WHERE gn-clie.codcia = cl-codcia AND gn-clie.codcli = Faccpedi.codcli NO-LOCK NO-ERROR.
    IF AVAILABLE gn-clie THEN DO:
        IF gn-clie.Libre_L01 = YES AND gn-clie.RucOld <> "SI" THEN s-Porpercepcion = 0.5.
        IF gn-clie.Libre_L01 = NO AND gn-clie.RucOld <> "SI" THEN s-Porpercepcion = 2.
    END.
    /* Ic 04 Julio 2013 
        gn-clie.Libre_L01   : PERCEPCTOR
        gn-clie.RucOld      : RETENEDOR
    */
    IF (FacCPedi.Cmpbnte = "BOL" OR (FacCPedi.Cmpbnte = "TCK" AND FacCPedi.Libre_C04 <> 'FAC')) 
        THEN s-Porpercepcion = 2.

/*     IF s-PorPercepcion = 0 THEN LEAVE PERCEPCION. */
    FOR EACH Facdpedi OF Faccpedi, 
        FIRST Almmmatg OF Facdpedi NO-LOCK,
        FIRST Almsfami OF Almmmatg NO-LOCK:
        ASSIGN
            Facdpedi.CanSol = 0
            Facdpedi.CanApr = 0.
        IF Almsfami.Libre_c05 = "SI" THEN
            ASSIGN
            Facdpedi.CanSol = s-PorPercepcion
            Facdpedi.CanApr = ROUND(Facdpedi.implin * s-PorPercepcion / 100, 2)
            pPercepcion = pPercepcion + ROUND(Facdpedi.implin * s-PorPercepcion / 100, 2).
    END.
    /* EN CASO DE BOLETAS HAY QUE CALCULAR POR CADA DOCUMENTO A GENERAR ¿? */
    /* NOTA: NO válido para COTIZACIONES */
    IF LOOKUP(Faccpedi.coddoc, 'COT,C/M') = 0 AND Faccpedi.Cmpbnte = "BOL" 
        THEN DO:
        f-ImpPercepcion = 0.
        f-LinPercepcion = 0.
        pPercepcion = 0.
        iCountItem = 0.
        /* Quiebre principal por Almacen Despacho */
        FOR EACH Facdpedi OF Faccpedi NO-LOCK,
            FIRST Almmmatg OF Facdpedi NO-LOCK,
            FIRST Almsfami OF Almmmatg NO-LOCK
            BREAK BY Facdpedi.almdes BY Facdpedi.codmat:    /* ORDEN ES IMPORTANTE, VER PROGRAMA ccb/b-canc-mayorista-cont.w */
            IF FIRST-OF(Facdpedi.almdes) THEN DO:
                iCountItem = 0.
                f-ImpPercepcion = 0.
                f-LinPercepcion = 0.
            END.
            /* Quiebre secundario por cantidad de items */
            iCountItem = iCountItem + 1.
            IF Almsfami.Libre_c05 = "SI" THEN 
                ASSIGN
                    f-ImpPercepcion = f-ImpPercepcion + Facdpedi.ImpLin
                    f-LinPercepcion = f-LinPercepcion + ROUND(Facdpedi.implin * s-PorPercepcion / 100, 2).
            IF LAST-OF(Facdpedi.almdes) OR iCountItem >= FILL-IN-items THEN DO:
                /* Verificamos nuevamente los importes */
                IF Faccpedi.codmon = 1 AND f-ImpPercepcion > ImpMinPercep THEN pPercepcion = pPercepcion + f-LinPercepcion.
                IF Faccpedi.codmon = 2 AND f-ImpPercepcion * Faccpedi.tpocmb > ImpMinPercep THEN pPercepcion = pPercepcion + f-LinPercepcion.
                f-ImpPercepcion = 0.
                f-LinPercepcion = 0.
                iCountItem = 0.
            END.
        END.
        IF pPercepcion <= 0 THEN s-PorPercepcion = 0.
    END.
    /* RHC 26/12/2013 EN CASO DE DIVISION 00060 PERCEPCIONES X C/ITEM > ImpMinPercep */
/*     IF Faccpedi.coddiv = "00060" AND Faccpedi.coddoc = "P/M"                                   */
/*         AND LOOKUP(Faccpedi.Cmpbnte, "BOL,TCK") > 0                                            */
/*         THEN DO:                                                                               */
/*         pPercepcion = 0.                                                                       */
/*         FOR EACH Facdpedi OF Faccpedi NO-LOCK,                                                 */
/*             FIRST Almmmatg OF Facdpedi NO-LOCK,                                                */
/*             FIRST Almsfami OF Almmmatg NO-LOCK:                                                */
/*             f-ImpPercepcion = 0.                                                               */
/*             f-LinPercepcion = 0.                                                               */
/*             IF Almsfami.Libre_c05 = "SI" THEN DO:                                              */
/*                 IF (Faccpedi.codmon = 1 AND Facdpedi.implin > ImpMinPercep) OR                 */
/*                     (Faccpedi.codmon = 2 AND Facdpedi.implin * Faccpedi.tpocmb > ImpMinPercep) */
/*                     THEN ASSIGN                                                                */
/*                     f-ImpPercepcion = Facdpedi.ImpLin                                          */
/*                     f-LinPercepcion = ROUND(Facdpedi.implin * s-PorPercepcion / 100, 2).       */
/*             END.                                                                               */
/*             IF Faccpedi.codmon = 1 THEN pPercepcion = pPercepcion + f-LinPercepcion.           */
/*             IF Faccpedi.codmon = 2 THEN pPercepcion = pPercepcion + f-LinPercepcion.           */
/*         END.                                                                                   */
/*         IF pPercepcion <= 0 THEN s-PorPercepcion = 0.                                          */
/*     END.                                                                                       */
    /* ******************************************************************* */
END.
ASSIGN
    Faccpedi.AcuBon[4] = s-PorPercepcion
    Faccpedi.AcuBon[5] = pPercepcion.

RETURN "OK".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


