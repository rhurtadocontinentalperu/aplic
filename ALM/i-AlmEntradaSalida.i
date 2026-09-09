&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Method-Library 
/*--------------------------------------------------------------------------
    Library     : 
    Purpose     :

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
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
   Type: Method-Library
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Method-Library ASSIGN
         HEIGHT             = 5.62
         WIDTH              = 52.29.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Method-Library 
/* ************************* Included-Libraries *********************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Method-Library 


/* ***************************  Main Block  *************************** */

DEFINE VAR cTipoMov AS CHAR.
DEFINE VAR xTipoMov AS CHAR.

DEFINE VAR codmatdesde AS CHAR.
DEFINE VAR codmathasta AS CHAR.

codmatdesde = FILL-IN-CodMat.
codmathasta = FILL-IN-CodMat2.
IF FILL-IN-CodMat = '' THEN codmatdesde = "000000".
IF FILL-IN-CodMat2 = '' THEN codmathasta = "zzzzzz".

cTipoMov = c-tipmov.
IF c-tipmov = 'A' THEN cTipoMov = "I,S".
/*
MESSAGE "codmat " codmatdesde SKIP
        "codmat2 " codmathasta SKIP
        "tipo " cTipoMov SKIP
        "FILL-IN-CodFam " FILL-IN-CodFam
        .
*/
DEFINE VAR iConteo AS INT.

REPEAT iConteo = 1 TO NUM-ENTRIES(cTipoMov,","):
    xtipomov = ENTRY(iConteo,cTipoMov,",").

    FOR EACH Almcmov NO-LOCK WHERE Almcmov.CodCia = s-codcia 
        AND Almcmov.CodAlm = Almacen.CodAlm 
        /*AND Almcmov.TipMov = x-Tipo */
        AND Almcmov.TipMov = xtipomov
        AND (C-CodMov = 88 OR Almcmov.CodMov = C-CodMov ) 
        AND Almcmov.FchDoc >= DesdeF AND Almcmov.FchDoc <= HastaF:
        FOR EACH Almdmov NO-LOCK WHERE Almdmov.CodCia = Almcmov.CodCia 
            AND Almdmov.CodAlm = Almcmov.CodAlm 
            AND Almdmov.TipMov = Almcmov.TipMov 
            AND Almdmov.CodMov = Almcmov.CodMov 
            AND Almdmov.NroSer = Almcmov.NroSer 
            AND Almdmov.NroDoc = Almcmov.NroDoc
            /*AND (FILL-IN-CodMat = '' OR Almdmov.codmat = FILL-IN-CodMat),*/
            AND (Almdmov.codmat >= codmatdesde AND Almdmov.codmat <= codmathasta),
            FIRST Almmmatg OF Almdmov NO-LOCK:
    
            /*IF NOT (FILL-IN-CodPro = '' OR Almmmatg.codpr1 = FILL-IN-CodPro) THEN NEXT.*/
            IF NOT (FILL-IN-CodPro = '' OR almcmov.codpro = FILL-IN-CodPro) THEN NEXT.
            IF NOT (FILL-IN-CodCli = '' OR almcmov.codcli = FILL-IN-Codcli) THEN NEXT.
            IF NOT (FILL-IN-CodFam = '' OR almmmatg.codfam = FILL-IN-Codfam) THEN NEXT.
            IF NOT (FILL-IN-CodSubFam = '' OR almmmatg.subfam = FILL-IN-CodSubfam) THEN NEXT.
            IF NOT (FILL-IN-CtgCtb = '' OR almmmatg.catconta[1] = FILL-IN-CtgCtb) THEN NEXT.
                    
            x-NroDoc = STRING(Almdmov.NroSer,"999") + "-" + STRING(Almcmov.Nrodoc,"9999999999").  
            IF Almdmov.CodMon <> 1
            THEN X-Valor = Almdmov.PreUni * Almdmov.TpoCmb.
            ELSE DO:
              x-Valor = Almdmov.PreUni.
            END.
                          
            CREATE Reporte.
            ASSIGN
                Reporte.CodAlm   = Almdmov.CodAlm
                Reporte.CodMov   = Almdmov.CodMov 
                Reporte.NroMov   = x-NroDoc
                Reporte.FchMov   = Almdmov.FchDoc
                Reporte.FchCbd   = Almcmov.DateUpdate
                Reporte.Usuario  = Almcmov.usuario
                Reporte.Estado   = Almcmov.FlgEst    
                Reporte.NroRe1   = Almcmov.NroRf1
                Reporte.NroRe2   = Almcmov.NroRf2
                Reporte.NroRe3   = Almcmov.NroRf3
                Reporte.AlmDes   = Almcmov.AlmDes 
                Reporte.CodMat   = Almmmatg.CodMat
                Reporte.DesMat   = Almmmatg.DesMat
                Reporte.UndBas   = Almdmov.CodUnd
                Reporte.DesMar   = Almmmatg.DesMar
                Reporte.CodPro   = Almcmov.CodPro
                Reporte.CodCli   = Almcmov.CodCli
                Reporte.CanMat   = Almdmov.CanDes * Almdmov.Factor            
                Reporte.CosUni   = x-valor
                Reporte.implin   = almdmov.implin
                reporte.observ  = almcmov.observ
                Reporte.Cco      = Almcmov.Cco
    
    /*RD01*****
                Reporte.CosUni   = f-precio
    **********/            
                Reporte.NueCos   = Almdmov.VctoMn1
                Reporte.CatConta = Almmmatg.CatConta[1]
                Reporte.CodPr1   = Almmmatg.CodPr1
                Reporte.CodPr2   = Almmmatg.CodPr2
                Reporte.Moneda   = (IF Almdmov.codmon = 2 THEN 'US$' ELSE 'S/.')
                Reporte.TpoCmb   = Almdmov.TpoCmb.
    
            /*Encuentra Numero Liquidacion*/
            /* */
            IF Almcmov.CodRef = "OP" THEN DO:
                /* Buscamos Orden de Produccion */
                FIND PR-ODPC WHERE PR-ODPC.codcia = s-codcia
                    AND PR-ODPC.numord = Almcmov.NroRef
                    NO-LOCK NO-ERROR.
                IF AVAILABLE PR-ODPC THEN DO:
                    FIND LAST PR-LIQC WHERE PR-LIQC.codcia = s-codcia
                        AND PR-LIQC.numord = PR-ODPC.numord
                        AND Almcmov.fchdoc >= PR-LIQC.fecini
                        AND Almcmov.fchdoc <= PR-LIQC.fecfin
                        AND PR-LIQC.flgest <> "A"
                        NO-LOCK NO-ERROR.
                    IF AVAILABLE PR-LIQC THEN Reporte.NumLiq = PR-LIQC.NumLiq.
    
                END.
            END.
            /*
                Ic - 07Set2016, correo Juan Almonte, O/D y G/R
            */
            FIND FIRST ccbcdocu WHERE ccbcdocu.codcia = s-codcia AND
                                    ccbcdocu.coddoc = almcmov.codref AND
                                    ccbcdocu.nrodoc = almcmov.nroref
                                    NO-LOCK NO-ERROR.
            IF AVAILABLE ccbcdocu THEN DO:
                ASSIGN Reporte.OrdDsp   = TRIM(ccbcdocu.libre_c01) + " - " + TRIM(ccbcdocu.libre_c02)
                        reporte.GRemi   = TRIM(ccbcdocu.codref) + " - " + TRIM(ccbcdocu.nroref)
                        Reporte.Monedaori   = (IF ccbcdocu.codmon = 2 THEN 'US$' ELSE 'S/.').
            END.
    
            /* */
            /* Proveedor */
            FIND gn-prov WHERE gn-prov.codcia = pv-codcia
                AND gn-prov.codpro = Reporte.codpro NO-LOCK NO-ERROR.
            IF AVAILABLE gn-prov THEN Reporte.despro = gn-prov.NomPro.
    
            /* Cliente */
            FIND gn-clie WHERE gn-clie.codcia = 1
                AND gn-clie.codcli = Reporte.codcli NO-LOCK NO-ERROR.
            IF AVAILABLE gn-clie THEN Reporte.descli = gn-clie.NomCli.
    
            DEF VAR x-Cadena AS CHAR NO-UNDO.
            RUN lib/limpiar-texto (Reporte.NroRe1,' ', OUTPUT x-Cadena).
            Reporte.NroRe1 = x-Cadena.
            RUN lib/limpiar-texto (Reporte.NroRe2,' ', OUTPUT x-Cadena).
            Reporte.NroRe2 = x-Cadena.
            RUN lib/limpiar-texto (Reporte.NroRe3,' ', OUTPUT x-Cadena).
            Reporte.NroRe3 = x-Cadena.
            RUN lib/limpiar-texto (Reporte.DesMar,' ', OUTPUT x-Cadena).
            Reporte.DesMar = x-Cadena.
            RUN lib/limpiar-texto (Reporte.DesMat,' ', OUTPUT x-Cadena).
            Reporte.DesMat = x-Cadena.
            RUN lib/limpiar-texto (Reporte.DesPro,' ', OUTPUT x-Cadena).
            Reporte.DesPro = x-Cadena.
            RUN lib/limpiar-texto (Reporte.Observ,' ', OUTPUT x-Cadena).
            Reporte.Observ = x-Cadena.
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


