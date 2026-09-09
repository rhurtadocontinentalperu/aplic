&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*--------------------------------------------------------------------------
    File        : 
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

&Scoped-define PROCEDURE-TYPE Procedure



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
         HEIGHT             = 2
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME
 



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
DEF SHARED VAR s-CodCia AS INT.

DISABLE TRIGGERS FOR LOAD OF Ventas.

DEF VAR x-CodFchI AS DATE.
DEF VAR x-CodFchF AS DATE.
DEF VAR x-Signo1 AS INT.
DEF VAR x-FmaPgo LIKE Ventas.FmaPgo.
DEF VAR x-TpoCmbCmp AS DEC.
DEF VAR x-TpoCmbVta AS DEC.
DEF VAR f-Factor AS DEC.

DEF BUFFER B-CDOCU FOR CcbCdocu.
 
x-codfchi = TODAY - DAY(TODAY) + 1.
x-codfchf = TODAY - 1.

x-codfchi = date(04,01,2005).
x-codfchf = date(04,30,2005).

DISPLAY x-CodFchI x-CodFchF.
PAUSE.
    
FOR EACH Gn-Divi USE-INDEX IDX01 NO-LOCK WHERE Gn-Divi.Codcia = S-CodCia
        AND gn-divi.coddiv >= '00002':
    /* Borramos la estadistica */
    FOR EACH Ventas WHERE Ventas.codcia = s-codcia
            AND Ventas.coddiv = Gn-Divi.coddiv
            AND Ventas.Fecha >= x-codfchi AND Ventas.Fecha <= x-codfchf:
        DELETE Ventas.
    END.            
    /* Logica principal */
    FOR EACH CcbCdocu USE-INDEX Llave10 NO-LOCK WHERE CcbCdocu.CodCia = S-CODCIA 
            AND CcbCdocu.CodDiv = Gn-Divi.CodDiv
            AND CcbCdocu.FchDoc >= x-CodFchI
            AND CcbCdocu.FchDoc <= x-CodFchF
            BREAK BY CcbCdocu.CodCia
                    BY CcbCdocu.CodDiv
                    BY CcbCdocu.FchDoc:
        /* ***************** FILTROS ********************************** */
        IF LOOKUP(CcbCDocu.CodDoc,"TCK,FAC,BOL,N/C,N/D") = 0 THEN NEXT.
        IF CcbCDocu.FlgEst = "A"  THEN NEXT.
        IF CcbCDocu.ImpCto = ? THEN NEXT.   /* Valores indefinidos */
        /* *********************************************************** */
        x-signo1 = IF CcbCdocu.Coddoc = "N/C" THEN -1 ELSE 1.
        DISPLAY CcbCdocu.Codcia
                CcbCdocu.Coddiv
                CcbCdocu.FchDoc 
                CcbCdocu.CodDoc
                CcbCdocu.NroDoc
                STRING(TIME,'HH:MM')
                TODAY .
        PAUSE 0.
     
        FIND LAST Gn-Tcmb WHERE Gn-Tcmb.Fecha <= CcbCdocu.FchDoc
                          USE-INDEX Cmb01
                          NO-LOCK NO-ERROR.
        IF NOT AVAIL Gn-Tcmb THEN 
            FIND FIRST Gn-Tcmb WHERE Gn-Tcmb.Fecha >= CcbCdocu.FchDoc
                               USE-INDEX Cmb01
                               NO-LOCK NO-ERROR.
        IF AVAIL Gn-Tcmb THEN 
            ASSIGN
            x-TpoCmbCmp = Gn-Tcmb.Compra
            x-TpoCmbVta = Gn-Tcmb.Venta.
            
        X-FMAPGO = CcbCdocu.FmaPgo.
        IF CcbCdocu.Coddoc = "N/C" THEN DO:
           FIND B-CDOCU WHERE B-CDOCU.Codcia = CcbCdocu.Codcia AND
                              B-CDOCU.Coddoc = CcbCdocu.Codref AND
                              B-CDOCU.NroDoc = CcbCdocu.Nroref
                              NO-LOCK NO-ERROR.
           IF AVAILABLE B-CDOCU THEN X-FMAPGO = B-CDOCU.FmaPgo.
        END.

        IF CcbCdocu.Coddoc = "N/C" AND CcbCdocu.CndCre = "N" THEN RUN PROCESA-NOTA.

        FOR EACH CcbDdocu OF CcbCdocu NO-LOCK,
                FIRST Almmmatg NO-LOCK WHERE Almmmatg.Codcia = CcbDdocu.Codcia 
                    AND Almmmatg.CodMat = CcbDdocu.CodMat:
            FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas AND  
                                Almtconv.Codalter = Ccbddocu.UndVta
                                NO-LOCK NO-ERROR.
            F-FACTOR  = 1. 
            IF AVAILABLE Almtconv THEN DO:
               F-FACTOR = Almtconv.Equival.
               IF Almmmatg.FacEqu <> 0 THEN F-FACTOR = Almtconv.Equival / Almmmatg.FacEqu.
            END.

            FIND Ventas WHERE ventas.codcia = ccbcdocu.codcia
                AND ventas.coddiv = ccbcdocu.coddiv
                AND ventas.codmat = ccbddocu.codmat
                AND ventas.codcli = ccbcdocu.codcli
                AND ventas.codpro = almmmatg.codpr1
                AND ventas.codven = ccbcdocu.codven
                AND ventas.fmapgo = ccbcdocu.fmapgo
                AND ventas.fecha  = ccbcdocu.fchdoc
                EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE Ventas
            THEN CREATE Ventas.
            ASSIGN
                ventas.codcia = ccbcdocu.codcia
                ventas.coddiv = ccbcdocu.coddiv
                ventas.codmat = ccbddocu.codmat                
                ventas.codcli = ccbcdocu.codcli
                ventas.codpro = almmmatg.codpr1
                ventas.codven = ccbcdocu.codven
                ventas.codfam = almmmatg.codfam
                ventas.subfam = almmmatg.subfam
                ventas.fmapgo = ccbcdocu.fmapgo
                ventas.licencia = almmmatg.licencia[1]
                ventas.fecha  = ccbcdocu.fchdoc.
            IF Ccbcdocu.CodMon = 1 
            THEN ASSIGN
                    Ventas.VentaMn = Ventas.VentaMn + (x-signo1 * ccbddocu.implin)
                    Ventas.VentaMe = Ventas.VentaMe + (x-signo1 * ccbddocu.implin / x-TpoCmbCmp)
                    Ventas.CostoMn = Ventas.CostoMn + (x-signo1 * ccbddocu.impcto)
                    Ventas.CostoMe = Ventas.CostoMe + (x-signo1 * ccbddocu.impcto / x-TpoCmbCmp).
            IF Ccbcdocu.CodMon = 2
            THEN ASSIGN
                    Ventas.VentaMe = Ventas.VentaMe + (x-signo1 * ccbddocu.implin)
                    Ventas.VentaMn = Ventas.VentaMn + (x-signo1 * ccbddocu.implin * x-TpoCmbVta)
                    Ventas.CostoMe = Ventas.CostoMe + (x-signo1 * ccbddocu.impcto)
                    Ventas.CostoMn = Ventas.CostoMn + (x-signo1 * ccbddocu.impcto * x-TpoCmbVta).
            ASSIGN
                Ventas.CanDes = Ventas.CanDes + (x-signo1 * ccbddocu.candes * f-factor).
        END.
     END.
END.

message 'proceso terminado'.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PROCESA-NOTA Procedure 
PROCEDURE PROCESA-NOTA :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
Def var x-coe       as deci init 0.
Def var x-can       as deci init 0.

FOR EACH CcbDdocu OF CcbCdocu:
    x-can = IF CcbDdocu.CodMat = "00005" THEN 1 ELSE 0.
END.
FIND B-CDOCU WHERE B-CDOCU.Codcia = CcbCdocu.Codcia AND
                   B-CDOCU.CodDoc = CcbCdocu.Codref AND
                   B-CDOCU.NroDoc = CcbCdocu.Nroref 
                   NO-LOCK NO-ERROR.
IF AVAILABLE B-CDOCU THEN DO:
    x-coe = CcbCdocu.ImpTot / B-CDOCU.ImpTot.
    FOR EACH CcbDdocu OF B-CDOCU NO-LOCK,
            FIRST Almmmatg WHERE Almmmatg.Codcia = CcbDdocu.Codcia  
                AND Almmmatg.CodMat = CcbDdocu.CodMat NO-LOCK:
        FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas AND  
                            Almtconv.Codalter = Ccbddocu.UndVta
                            NO-LOCK NO-ERROR.
        F-FACTOR  = 1. 
        IF AVAILABLE Almtconv THEN DO:
           F-FACTOR = Almtconv.Equival.
           IF Almmmatg.FacEqu <> 0 THEN F-FACTOR = Almtconv.Equival / Almmmatg.FacEqu.
        END.



        FIND Ventas WHERE ventas.codcia = ccbcdocu.codcia
            AND ventas.coddiv = ccbcdocu.coddiv
            AND ventas.codmat = ccbddocu.codmat
            AND ventas.codcli = ccbcdocu.codcli
            AND ventas.codpro = almmmatg.codpr1
            AND ventas.codven = ccbcdocu.codven
            AND ventas.fmapgo = ccbcdocu.fmapgo
            AND ventas.fecha  = ccbcdocu.fchdoc
            EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE Ventas
        THEN CREATE Ventas.
        ASSIGN
            ventas.codcia = ccbcdocu.codcia
            ventas.coddiv = ccbcdocu.coddiv
            ventas.codmat = ccbddocu.codmat                
            ventas.codcli = ccbcdocu.codcli
            ventas.codpro = almmmatg.codpr1
            ventas.codven = ccbcdocu.codven
            ventas.codfam = almmmatg.codfam
            ventas.subfam = almmmatg.subfam
            ventas.fmapgo = ccbcdocu.fmapgo
            ventas.licencia = almmmatg.licencia[1]
            ventas.fecha  = ccbcdocu.fchdoc.
        IF Ccbcdocu.CodMon = 1 
        THEN ASSIGN
                Ventas.VentaMn = Ventas.VentaMn + (x-signo1 * ccbddocu.implin * x-coe)
                Ventas.VentaMe = Ventas.VentaMe + (x-signo1 * ccbddocu.implin * x-coe / x-TpoCmbCmp)
                Ventas.CostoMn = Ventas.CostoMn + (x-signo1 * ccbddocu.impcto * x-coe)
                Ventas.CostoMe = Ventas.CostoMe + (x-signo1 * ccbddocu.impcto * x-coe / x-TpoCmbCmp).
        IF Ccbcdocu.CodMon = 2
        THEN ASSIGN
                Ventas.VentaMe = Ventas.VentaMe + (x-signo1 * ccbddocu.implin * x-coe)
                Ventas.VentaMn = Ventas.VentaMn + (x-signo1 * ccbddocu.implin * x-TpoCmbVta)
                Ventas.CostoMe = Ventas.CostoMe + (x-signo1 * ccbddocu.impcto * x-coe)
                Ventas.CostoMn = Ventas.CostoMn + (x-signo1 * ccbddocu.impcto * x-coe * x-TpoCmbVta).
        ASSIGN
            Ventas.CanDes = Ventas.CanDes + (x-signo1 * ccbddocu.candes * f-factor).
    END.
END.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


