&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : 
    Purpose     : Resume el pedido por division y determina en que estado
                    debería generarse la orden de despacho
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
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
DEF INPUT PARAMETER s-codcia AS INT.
DEF INPUT PARAMETER s-codalm AS CHAR.
DEF INPUT PARAMETER s-codmon AS INT.
DEF INPUT PARAMETER s-tpocmb AS DEC.
DEF INPUT PARAMETER s-flgenv AS LOG.

DEF SHARED TEMP-TABLE T-CPEDI NO-UNDO LIKE FacCPedi.
DEF SHARED TEMP-TABLE PEDI    NO-UNDO LIKE FacDPedi.

FOR EACH T-CPEDI:
    DELETE T-CPEDI.
END.

/* ACUMULAMOS POR DIVISION */
FOR EACH PEDI, FIRST Almacen NO-LOCK WHERE Almacen.codcia = s-codcia
    AND Almacen.codalm = PEDI.almdes
    BREAK BY Almacen.coddiv:
    IF FIRST-OF (Almacen.coddiv) THEN DO:
        CREATE T-CPEDI.
        ASSIGN
            T-CPEDI.codcia = s-codcia
            T-CPEDI.coddiv = Almacen.coddiv
            T-CPEDI.nroped = STRING(RANDOM(1,999999), '999999')
            T-CPEDI.Glosa  = "OK"
            T-CPEDI.CodMon = s-codmon
            T-CPEDI.TpoCmb = s-tpocmb
            T-CPEDI.flgest = "P".
    END.
    T-CPEDI.ImpTot = T-CPEDI.ImpTot + PEDI.ImpLin.
END.
IF s-FlgEnv = NO THEN RETURN.
DEF VAR x-ImpTot AS DEC NO-UNDO.        /* en Soles */
/* IMPORTE TOTAL EN SOLES */
FOR EACH T-CPEDI:
    x-ImpTot = T-CPEDI.ImpTot.
    IF T-CPEDI.codmon = 2 THEN x-ImpTot = T-CPEDI.ImpTot * s-TpoCmb.
    T-CPEDI.ImpTot = x-ImpTot.
END.
/* OBSERVACIONES DE ACUERDO AL IMPORTE Y A LA UBICACION DEL CLIENTE */
DEF VAR i AS INT NO-UNDO.
FIND Faccfggn WHERE Faccfggn.codcia = s-codcia NO-LOCK.
/* DO i = 1 TO NUM-ENTRIES(s-codalm):                                                                      */
/*     FIND Almacen WHERE Almacen.codcia = s-codcia                                                        */
/*         AND Almacen.codalm = ENTRY(i, s-codalm)                                                         */
/*         NO-LOCK NO-ERROR.                                                                               */
/*     IF NOT AVAILABLE Almacen THEN NEXT.                                                                 */
/*     FIND T-CPEDI WHERE T-CPEDI.coddiv = Almacen.coddiv NO-ERROR.                                        */
/*     IF NOT AVAILABLE T-CPEDI THEN NEXT.                                                                 */
/*     IF FacCfgGn.MrgMin > 0 AND T-CPEDI.ImpTot < FacCfgGn.MrgMin                                         */
/*         THEN ASSIGN                                                                                     */
/*             T-CPEDI.Glosa = "ERROR: EL IMPORTE ES MENOR A S/." + STRING(FacCfgGn.MrgMin, ">>>,>>9.99")  */
/*             T-CPEDI.FlgEst = "A"                                                                        */
/*             T-CPEDI.FlgIgv = NO.                                                                        */
/*     IF FacCfgGn.MrgMay > 0 AND (T-CPEDI.ImpTot >= FacCfgGn.MrgMin AND T-CPEDI.ImpTot < FacCfgGn.MrgMay) */
/*         THEN ASSIGN                                                                                     */
/*             T-CPEDI.Glosa = "LA ORDEN DE DESPACHO TENDRÁ QUE SER APROBADA"                              */
/*             T-CPEDI.FlgEst = "X"                                                                        */
/*             T-CPEDI.FlgIgv = YES.                                                                       */
/*     /* EL PRIMER ALMACEN NO TIENE RESTRICCIONES */                                                      */
/*     IF i = 1                                                                                            */
/*         THEN ASSIGN                                                                                     */
/*             T-CPEDI.Glosa = "TODO OK"                                                                   */
/*             T-CPEDI.FlgEst = "P"                                                                        */
/*             T-CPEDI.FlgIgv = YES.                                                                       */
/* END.                                                                                                    */

FOR EACH T-CPEDI:
    IF FacCfgGn.MrgMin > 0 AND T-CPEDI.ImpTot < FacCfgGn.MrgMin 
        THEN ASSIGN
            T-CPEDI.Glosa = "ERROR: EL IMPORTE ES MENOR A S/." + STRING(FacCfgGn.MrgMin, ">>>,>>9.99")
            T-CPEDI.FlgEst = "A"
            T-CPEDI.FlgIgv = NO.
    IF FacCfgGn.MrgMay > 0 AND (T-CPEDI.ImpTot >= FacCfgGn.MrgMin AND T-CPEDI.ImpTot < FacCfgGn.MrgMay)
        THEN ASSIGN
            T-CPEDI.Glosa = "LA ORDEN DE DESPACHO TENDRÁ QUE SER APROBADA"
            T-CPEDI.FlgEst = "X"
            T-CPEDI.FlgIgv = YES.
    /* EL PRIMER ALMACEN NO TIENE RESTRICCIONES */
    FIND Almacen WHERE Almacen.codcia = s-codcia
        AND Almacen.codalm = ENTRY(1, s-codalm)
        NO-LOCK NO-ERROR.
    IF Almacen.coddiv = T-CPEDI.coddiv
        THEN ASSIGN
            T-CPEDI.Glosa = "TODO OK"
            T-CPEDI.FlgEst = "P"
            T-CPEDI.FlgIgv = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


