&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
          cissac           PROGRESS
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER CCMP FOR INTEGRAL.LG-COCmp.
DEFINE BUFFER CCOT FOR cissac.FacCPedi.
DEFINE BUFFER CPED FOR cissac.FacCPedi.
DEFINE TEMP-TABLE DCMP NO-UNDO LIKE INTEGRAL.LG-DOCmp.
DEFINE BUFFER DCOT FOR cissac.FacDPedi.
DEFINE BUFFER DPED FOR cissac.FacDPedi.
DEFINE TEMP-TABLE RDOCU NO-UNDO LIKE INTEGRAL.CcbDDocu.
DEFINE TEMP-TABLE T-GUIAS NO-UNDO LIKE cissac.CcbCDocu.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
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

DEF INPUT PARAMETER COMBO-BOX-NroMes AS INT.
DEF INPUT PARAMETER COMBO-BOX-Periodo AS INT.
DEF INPUT PARAMETER TABLE FOR RDOCU.

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR pv-codcia AS INT.
DEF SHARED VAR cl-codcia AS INT.
DEF SHARED VAR s-user-id AS CHAR.
DEF VAR s-coddoc AS CHAR NO-UNDO.

DISABLE TRIGGERS FOR LOAD OF cissac.ccbcdocu.
DISABLE TRIGGERS FOR LOAD OF cissac.ccbddocu.
DISABLE TRIGGERS FOR LOAD OF cissac.almacen.
DISABLE TRIGGERS FOR LOAD OF cissac.almcmov.
DISABLE TRIGGERS FOR LOAD OF cissac.almdmov.
DISABLE TRIGGERS FOR LOAD OF cissac.faccpedi.
DISABLE TRIGGERS FOR LOAD OF cissac.facdpedi.
DISABLE TRIGGERS FOR LOAD OF cissac.almmmatg.
DISABLE TRIGGERS FOR LOAD OF cissac.almmmate.
DISABLE TRIGGERS FOR LOAD OF cissac.faccorre.

DISABLE TRIGGERS FOR LOAD OF integral.almacen.
DISABLE TRIGGERS FOR LOAD OF integral.almcmov.
DISABLE TRIGGERS FOR LOAD OF integral.almdmov.
DISABLE TRIGGERS FOR LOAD OF integral.almmmatg.
DISABLE TRIGGERS FOR LOAD OF integral.almmmate.
DISABLE TRIGGERS FOR LOAD OF integral.lg-cocmp.
DISABLE TRIGGERS FOR LOAD OF integral.lg-docmp.

DEF VAR pRowid AS ROWID NO-UNDO.

DEF VAR FILL-IN-CodAlm AS CHAR INIT "21" NO-UNDO.
DEF VAR FILL-IN-AlmIng AS CHAR INIT "21" NO-UNDO.
DEF VAR COMBO-BOX-NroSerCot AS INT INIT 021 NO-UNDO.
DEF VAR COMBO-BOX-NroSerPed AS INT INIT 021 NO-UNDO.
DEF VAR COMBO-BOX-NroSerOD AS INT INIT 021 NO-UNDO.
DEF VAR COMBO-BOX-NroSerGR AS INT INIT 921 NO-UNDO.
DEF VAR COMBO-BOX-NroSerFac AS INT INIT 921 NO-UNDO.

DEF VAR s-coddiv AS CHAR NO-UNDO.
DEF VAR s-codalm AS CHAR NO-UNDO.
DEF VAR s-porigv LIKE integral.ccbcdocu.porigv NO-UNDO.
DEF VAR I-NITEM  AS INT NO-UNDO.
DEF VAR F-FACTOR AS DEC NO-UNDO.
DEF VAR F-IGV    AS DEC NO-UNDO.
DEF VAR F-ISC    AS DEC NO-UNDO.
DEF VAR x-NroCot AS ROWID NO-UNDO.
DEF VAR x-NroPed AS ROWID NO-UNDO.
DEF VAR x-NroOD  AS ROWID NO-UNDO.
DEF VAR x-NroRf2 AS CHAR NO-UNDO.
DEF VAR x-NroRf3 AS CHAR NO-UNDO.

FIND cissac.Almacen WHERE cissac.Almacen.codcia = s-codcia
    AND cissac.Almacen.codalm = FILL-IN-CodAlm
    NO-LOCK NO-ERROR.
ASSIGN
    s-codalm = cissac.Almacen.codalm
    s-coddiv = cissac.Almacen.coddiv.

FIND integral.FacCfgGn WHERE integral.FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.
s-PorIgv = FacCfgGn.PorIgv.

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
   Temp-Tables and Buffers:
      TABLE: CCMP B "?" ? INTEGRAL LG-COCmp
      TABLE: CCOT B "?" ? cissac FacCPedi
      TABLE: CPED B "?" ? cissac FacCPedi
      TABLE: DCMP T "?" NO-UNDO INTEGRAL LG-DOCmp
      TABLE: DCOT B "?" ? cissac FacDPedi
      TABLE: DPED B "?" ? cissac FacDPedi
      TABLE: RDOCU T "?" NO-UNDO INTEGRAL CcbDDocu
      TABLE: T-GUIAS T "?" NO-UNDO cissac CcbCDocu
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 9.92
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    RUN Orden-de-Compra-Conti-a-Cissac.
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
    
    RUN Genera-Venta-Cissac-Conti.
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
END.

RETURN 'OK'.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-act_alm) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE act_alm Procedure 
PROCEDURE act_alm :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER X-ROWID AS ROWID.

DEF VAR c-codalm AS CHAR.

FIND cissac.ccbcdocu WHERE ROWID(cissac.ccbcdocu) = X-ROWID NO-LOCK NO-ERROR.
IF NOT AVAILABLE cissac.ccbcdocu THEN RETURN 'OK'.

c-codalm = cissac.ccbcdocu.codalm.

DEF VAR i AS INTEGER INITIAL 1 NO-UNDO.

DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN 'ADM-ERROR':
   /* Correlativo de Salida */
   FIND CURRENT cissac.ccbcdocu EXCLUSIVE-LOCK NO-ERROR.
   IF ERROR-STATUS:ERROR THEN RETURN 'ADM-ERROR'.
   FIND cissac.Almacen WHERE 
        cissac.Almacen.CodCia = s-codcia AND
        /*cissac.Almacen.CodAlm = s-codalm */
        cissac.Almacen.CodAlm = c-codalm       /* OJO */
        EXCLUSIVE-LOCK NO-ERROR.
   IF ERROR-STATUS:ERROR THEN UNDO, RETURN 'ADM-ERROR'.
   CREATE cissac.almcmov.
   ASSIGN cissac.almcmov.CodCia  = cissac.ccbcdocu.CodCia 
          cissac.almcmov.CodAlm  = cissac.ccbcdocu.CodAlm 
          cissac.almcmov.TipMov  = "S"
          cissac.almcmov.CodMov  = cissac.ccbcdocu.CodMov
          cissac.almcmov.NroSer  = 0 /* INTEGER(SUBSTRING(cissac.ccbcdocu.NroDoc,1,3)) */
          cissac.almcmov.NroDoc  = cissac.Almacen.CorrSal 
          cissac.Almacen.CorrSal = cissac.Almacen.CorrSal + 1
          cissac.almcmov.FchDoc  = cissac.ccbcdocu.FchDoc
          cissac.almcmov.HorSal  = STRING(TIME, "HH:MM:SS")
          cissac.almcmov.CodVen  = cissac.ccbcdocu.CodVen
          cissac.almcmov.CodCli  = cissac.ccbcdocu.CodCli
          cissac.almcmov.Nomref  = cissac.ccbcdocu.NomCli
          cissac.almcmov.CodRef  = cissac.ccbcdocu.CodDoc
          cissac.almcmov.NroRef  = cissac.ccbcdocu.nrodoc
          cissac.almcmov.NroRf1  = SUBSTRING(cissac.ccbcdocu.CodDoc,1,1) + cissac.ccbcdocu.NroDoc
          cissac.almcmov.NroRf2  = cissac.ccbcdocu.NroPed
          cissac.almcmov.usuario = s-user-id
          cissac.ccbcdocu.NroSal = STRING(cissac.almcmov.NroDoc).
   
   DETALLE:
   FOR EACH cissac.ccbddocu OF cissac.ccbcdocu NO-LOCK:
        /* RHC 22.10.08 FACTURAS ADELANTADAS */            
        IF cissac.ccbddocu.implin < 0 THEN NEXT DETALLE.
        
       CREATE cissac.Almdmov.
       ASSIGN cissac.Almdmov.CodCia = cissac.almcmov.CodCia
              cissac.Almdmov.CodAlm = cissac.almcmov.CodAlm
              cissac.Almdmov.CodMov = cissac.almcmov.CodMov 
              cissac.Almdmov.NroSer = cissac.almcmov.nroser
              cissac.Almdmov.NroDoc = cissac.almcmov.nrodoc
              cissac.Almdmov.AftIgv = cissac.ccbddocu.aftigv
              cissac.Almdmov.AftIsc = cissac.ccbddocu.aftisc
              cissac.Almdmov.CanDes = cissac.ccbddocu.candes
              cissac.Almdmov.codmat = cissac.ccbddocu.codmat
              cissac.Almdmov.CodMon = cissac.ccbcdocu.codmon
              cissac.Almdmov.CodUnd = cissac.ccbddocu.undvta
              cissac.Almdmov.Factor = cissac.ccbddocu.factor
              cissac.Almdmov.FchDoc = cissac.ccbcdocu.FchDoc
              cissac.Almdmov.ImpDto = cissac.ccbddocu.impdto
              cissac.Almdmov.ImpIgv = cissac.ccbddocu.impigv
              cissac.Almdmov.ImpIsc = cissac.ccbddocu.impisc
              cissac.Almdmov.ImpLin = cissac.ccbddocu.implin
              cissac.Almdmov.NroItm = i
              cissac.Almdmov.PorDto = cissac.ccbddocu.pordto
              cissac.Almdmov.PreBas = cissac.ccbddocu.prebas
              cissac.Almdmov.PreUni = cissac.ccbddocu.preuni
              cissac.Almdmov.TipMov = "S"
              cissac.Almdmov.TpoCmb = cissac.ccbcdocu.tpocmb
              cissac.almcmov.TotItm = i
              cissac.Almdmov.HraDoc = cissac.almcmov.HorSal
              i = i + 1.
/*        RUN almdcstk (ROWID(cissac.Almdmov)).                        */
/*        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'. */
/*        /* RHC 05.04.04 ACTIVAMOS KARDEX POR cissac.Almacen */       */
/*        RUN almacpr1 (ROWID(cissac.Almdmov), 'U').                   */
/*        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'. */
   END.
END.
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Genera-Cotizacion) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Cotizacion Procedure 
PROCEDURE Genera-Cotizacion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-NroDoc AS INT NO-UNDO.        
DEF VAR x-FechaD AS DATE NO-UNDO.
DEF VAR x-FechaH AS DATE NO-UNDO.

RUN src/bin/_dateif (COMBO-BOX-NroMes, COMBO-BOX-Periodo, OUTPUT x-FechaD, OUTPUT x-FechaH).
x-FechaH = x-FechaH + 1.

DO TRANSACTION ON ERROR UNDO, RETURN ERROR ON STOP UNDO, RETURN ERROR:
    FIND cissac.FacCorre WHERE cissac.FacCorre.CodCia = S-CODCIA 
        AND cissac.FacCorre.CodDoc = s-coddoc
        AND cissac.FacCorre.NroSer = COMBO-BOX-NroSerCot
        EXCLUSIVE-LOCK NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        MESSAGE 'NO se pudo bloquear el correlativo de' s-coddoc
            VIEW-AS ALERT-BOX ERROR TITLE "Cotización de CISSAC a CONTINENTAL".
        UNDO, RETURN ERROR.
    END.
    ASSIGN
        x-NroDoc = cissac.FacCorre.Correlativo.
    REPEAT:
        IF NOT CAN-FIND(FIRST cissac.FacCPedi WHERE cissac.FacCPedi.CodCia = S-CODCIA
                        AND cissac.FacCPedi.CodDiv = s-coddiv
                        AND cissac.FacCPedi.CodDoc = s-coddoc 
                        AND cissac.FacCPedi.NroPed = STRING(cissac.FacCorre.NroSer,"999") + STRING(x-NroDoc,"999999")
                        NO-LOCK)
            THEN LEAVE.
        x-NroDoc = x-NroDoc + 1.
    END.
    CREATE cissac.FacCPedi.
    ASSIGN 
        cissac.FacCPedi.CodCia = S-CODCIA
        cissac.FacCPedi.CodDiv = s-coddiv
        cissac.FacCPedi.CodDoc = s-coddoc 
        cissac.FacCPedi.FchPed = x-FechaH
        cissac.FacCPedi.FchVen = (x-FechaH + 7)
        cissac.FacCPedi.CodAlm = S-CODALM
        cissac.FacCPedi.PorIgv = s-PorIgv 
        cissac.FacCPedi.NroPed = STRING(cissac.FacCorre.NroSer,"999") + STRING(x-NroDoc,"999999")
        cissac.FacCPedi.TpoPed = ""
        cissac.FacCPedi.Hora = STRING(TIME,"HH:MM")
        cissac.FacCPedi.FlgImpOD = YES
        cissac.FacCPedi.CodCli = cissac.gn-clie.codcli
        cissac.FacCPedi.NomCli = cissac.gn-clie.nomcli
        cissac.FacCPedi.DirCli = cissac.gn-clie.dircli
        cissac.FacCPedi.RucCli = cissac.gn-clie.ruc
        cissac.FacCPedi.CodVen = cissac.gn-clie.CodVen
        cissac.Faccpedi.fmapgo = ENTRY(1, cissac.gn-clie.cndvta)
        cissac.FacCPedi.CodMon = integral.Lg-cocmp.codmon
        cissac.FacCPedi.FlgIgv =  YES
        cissac.FacCPedi.Usuario = S-USER-ID
        cissac.FacCPedi.TipVta  = "1"
        cissac.FacCPedi.FlgEst  = "C"       /* CERRADO */
        cissac.FacCPedi.Libre_c01 = STRING(COMBO-BOX-Periodo, '9999') + STRING(COMBO-BOX-nroMes, '99')
        cissac.FacCPedi.Libre_c02 = "DEVCOCI".
    ASSIGN 
        cissac.FacCorre.Correlativo = x-NroDoc + 1.
    i-nItem = 0.
    FOR EACH integral.Lg-docmp OF integral.Lg-cocmp, 
        FIRST cissac.Almmmatg OF integral.Lg-docmp NO-LOCK:
        f-Factor = 1.
        FIND cissac.Almtconv WHERE cissac.Almtconv.CodUnid = cissac.Almmmatg.UndBas 
            AND  cissac.Almtconv.Codalter = integral.Lg-docmp.UndCmp
            NO-LOCK NO-ERROR.
        IF AVAILABLE cissac.Almtconv THEN F-FACTOR = cissac.Almtconv.Equival.
        I-NITEM = I-NITEM + 1.
        CREATE cissac.FacDPedi.
        ASSIGN 
            cissac.FacDPedi.CodCia = cissac.FacCPedi.CodCia
            cissac.FacDPedi.CodDiv = cissac.FacCPedi.CodDiv
            cissac.FacDPedi.coddoc = cissac.FacCPedi.coddoc
            cissac.FacDPedi.NroPed = cissac.FacCPedi.NroPed
            cissac.FacDPedi.FchPed = cissac.FacCPedi.FchPed
            cissac.FacDPedi.Hora   = cissac.FacCPedi.Hora 
            cissac.FacDPedi.FlgEst = cissac.FacCPedi.FlgEst
            cissac.FacDPedi.codmat = integral.Lg-docmp.codmat 
            cissac.FacDPedi.Factor = f-Factor
            cissac.FacDPedi.CanPed = integral.Lg-docmp.CanPed 
            cissac.FacDPedi.CanAte = integral.Lg-docmp.CanPed       /* OJO */
            cissac.FacDPedi.ImpLin = ROUND( (integral.Lg-docmp.CanPed * integral.Lg-docmp.PreUni) * 
                                            (1 - (integral.Lg-docmp.Dsctos[1] / 100)) *
                                            (1 - (integral.Lg-docmp.Dsctos[2] / 100)) *
                                            (1 - (integral.Lg-docmp.Dsctos[3] / 100)) *
                                            (1 + (INTEGRAL.LG-DOCmp.IgvMat / 100)), 2)
            cissac.FacDPedi.NroItm = I-NITEM 
            cissac.FacDPedi.PreUni = integral.Lg-docmp.PreUni * ( 1 + (INTEGRAL.LG-DOCmp.IgvMat / 100) )
            cissac.FacDPedi.UndVta = integral.Lg-docmp.UndCmp
            cissac.FacDPedi.AftIgv = (IF INTEGRAL.LG-DOCmp.IgvMat > 0 THEN YES ELSE NO)
            cissac.FacDPedi.AftIsc = NO
            cissac.FacDPedi.ImpIgv = cissac.FacDPedi.ImpLin - 
                                    ROUND(cissac.FacDPedi.ImpLin  / (1 + (INTEGRAL.LG-DOCmp.IgvMat / 100)),4)
            cissac.FacDPedi.ImpDto = (integral.Lg-docmp.CanPed * integral.Lg-docmp.PreUni) - 
                                        cissac.FacDPedi.ImpLin
            /*cissac.FacDPedi.ImpIsc = integral.Lg-docmp.ImpIsc */
            cissac.FacDPedi.PreBas = integral.Lg-docmp.PreUni 
            cissac.FacDPedi.Por_DSCTOS[1] = ( 1 - ( (1 - integral.Lg-docmp.Dsctos[1] / 100) *
                                             (1 - integral.Lg-docmp.Dsctos[2] / 100) *
                                             (1 - integral.Lg-docmp.Dsctos[3] / 100) )
                                       ) * 100.
            /*cissac.FacDPedi.CodAux = integral.Lg-docmp.CodAux */
            /*cissac.FacDPedi.Por_Dsctos[1] = integral.Lg-docmp.Dsctos[1]*/
            /*cissac.FacDPedi.Por_Dsctos[2] = integral.Lg-docmp.Dsctos[2]*/
            /*cissac.FacDPedi.Por_Dsctos[3] = integral.Lg-docmp.Dsctos[3]*/
            /*cissac.FacDPedi.PesMat = integral.Lg-docmp.PesMat*/
        IF cissac.FacDPedi.ImpDto <= 0.1 THEN cissac.FacDPedi.ImpDto = 0.
        ASSIGN
            INTEGRAL.LG-DOCmp.CanAten = INTEGRAL.LG-DOCmp.CanPed.
    END.
    ASSIGN
        cissac.FacCPedi.ImpDto = 0
        cissac.FacCPedi.ImpIgv = 0
        cissac.FacCPedi.ImpIsc = 0
        cissac.FacCPedi.ImpTot = 0
        cissac.FacCPedi.ImpExo = 0
        F-Igv = 0
        F-Isc = 0.
    FOR EACH cissac.FacDPedi OF cissac.FacCPedi NO-LOCK:
        F-Igv = F-Igv + cissac.FacDPedi.ImpIgv.
        F-Isc = F-Isc + cissac.FacDPedi.ImpIsc.
        cissac.FacCPedi.ImpTot = cissac.FacCPedi.ImpTot + cissac.FacDPedi.ImpLin.
        IF NOT cissac.FacDPedi.AftIgv THEN cissac.FacCPedi.ImpExo = cissac.FacCPedi.ImpExo + cissac.FacDPedi.ImpLin.
        IF cissac.FacDPedi.AftIgv = YES
            THEN cissac.FacCPedi.ImpDto = cissac.FacCPedi.ImpDto + ROUND(cissac.FacDPedi.ImpDto / (1 + cissac.FacCPedi.PorIgv / 100), 2).
        ELSE cissac.FacCPedi.ImpDto = cissac.FacCPedi.ImpDto + cissac.FacDPedi.ImpDto.
    END.
    ASSIGN
        cissac.FacCPedi.ImpIgv = ROUND(F-IGV,2)
        cissac.FacCPedi.ImpIsc = ROUND(F-ISC,2)
        cissac.FacCPedi.ImpVta = cissac.FacCPedi.ImpTot - cissac.FacCPedi.ImpExo - cissac.FacCPedi.ImpIgv
        cissac.FacCPedi.ImpBrt = cissac.FacCPedi.ImpVta + cissac.FacCPedi.ImpIsc + cissac.FacCPedi.ImpDto + cissac.FacCPedi.ImpExo.
    x-NroCot = ROWID(cissac.FacCPedi).
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Genera-Facturas) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Facturas Procedure 
PROCEDURE Genera-Facturas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE C-NROPED AS CHAR      NO-UNDO.
DEFINE VARIABLE x-NroDoc AS INT NO-UNDO.

DEFINE BUFFER BDDOCU FOR cissac.CcbDDocu.

DO TRANSACTION ON ERROR UNDO, RETURN ERROR ON STOP UNDO, RETURN ERROR:
    FIND cissac.FacCorre WHERE cissac.FacCorre.CodCia = S-CODCIA 
        AND cissac.FacCorre.CodDoc = S-CODDOC 
        AND cissac.FacCorre.NroSer = COMBO-BOX-NroSerFac EXCLUSIVE-LOCK NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        MESSAGE 'NO se pudo bloquear el correlativo de' s-coddoc
            VIEW-AS ALERT-BOX ERROR TITLE 'Facturas de CISSAC a CONTINENTAL'.
        UNDO, RETURN ERROR.
    END.

    FOR EACH T-GUIAS NO-LOCK:
        FIND cissac.FacCPedi WHERE cissac.FacCPedi.CODCIA = S-CODCIA 
            AND cissac.FacCPedi.CODDOC = T-GUIAS.CodPed
            AND cissac.FacCPedi.NROPED = T-GUIAS.NroPed
            NO-LOCK NO-ERROR.
        C-NROPED = cissac.FacCPedi.NROREF.
        ASSIGN
            x-NroDoc = cissac.FacCorre.Correlativo.
        REPEAT:
            IF NOT CAN-FIND(FIRST cissac.CcbCDocu WHERE cissac.CcbCDocu.CodCia = s-CodCia
                            AND cissac.CcbCDocu.CodDiv = s-CodDiv
                            AND cissac.CcbCDocu.CodDoc = s-CodDoc
                            AND cissac.CcbCDocu.NroDoc = STRING(cissac.FacCorre.NroSer,"999") + STRING(x-NroDoc,"999999") 
                            NO-LOCK)
                THEN LEAVE.
            x-NroDoc = x-NroDoc + 1.
        END.
        CREATE cissac.CcbCDocu.
        BUFFER-COPY T-GUIAS
            TO cissac.CcbCDocu
            ASSIGN 
            cissac.CcbCDocu.CodCia = S-CODCIA
            cissac.CcbCDocu.CodDiv = S-CODDIV
            cissac.CcbCDocu.CodDoc = S-CODDOC
            cissac.CcbCDocu.NroDoc = STRING(cissac.FacCorre.NroSer,"999") + STRING(x-NroDoc,"999999")
            cissac.CcbCDocu.CodAlm = S-CODALM
            cissac.CcbCDocu.CodMov = 02
            cissac.CcbCDocu.FchDoc = cissac.FacCPedi.FchPed
            cissac.CcbCDocu.FchAte = cissac.FacCPedi.FchPed
            cissac.CcbCDocu.FlgEst = "P"
            cissac.CcbCDocu.FlgAte = "P"
            cissac.CcbCDocu.CodPed = "PED"
            cissac.CcbCDocu.NroPed = C-NROPED
            cissac.CcbCDocu.CodRef = "G/R"
            cissac.CcbCDocu.NroRef = T-GUIAS.NroDoc
            cissac.CcbCDocu.Tipo   = "OFICINA"
            cissac.CcbCDocu.TipVta = "2"
            cissac.CcbCDocu.TpoFac = "R"
            cissac.CcbCDocu.FlgAte = 'D'
            cissac.CcbCDocu.usuario = S-USER-ID
            cissac.CcbCDocu.TipBon[1] = cissac.FacCPedi.TipBon[1]
            cissac.CcbCDocu.HorCie = "00:01:01".
        ASSIGN
            cissac.FacCorre.Correlativo = x-NroDoc + 1.

        FIND cissac.gn-clie WHERE cissac.gn-clie.CodCia = cl-codcia 
            AND cissac.gn-clie.CodCli = cissac.CcbCDocu.CodCli NO-LOCK NO-ERROR.
        IF AVAILABLE cissac.gn-clie THEN DO:
           ASSIGN cissac.CcbCDocu.CodDpto = cissac.gn-clie.CodDept 
                  cissac.CcbCDocu.CodProv = cissac.gn-clie.CodProv 
                  cissac.CcbCDocu.CodDist = cissac.gn-clie.CodDist.
        END.
        /* ACTUALIZAR EL CENTRO DE COSTO 22.07.04 CY */
        FIND cissac.gn-ven WHERE cissac.gn-ven.codcia = s-codcia
           AND cissac.gn-ven.codven = cissac.CcbCDocu.codven
           NO-LOCK NO-ERROR.
        IF AVAILABLE cissac.gn-ven THEN cissac.CcbCDocu.cco = cissac.gn-ven.cco.

        FOR EACH BDDOCU OF T-GUIAS NO-LOCK:
            CREATE cissac.CcbDDocu.
            BUFFER-COPY BDDOCU
                TO cissac.CcbDDocu
                ASSIGN 
                cissac.CcbDDocu.CodCia = cissac.CcbCDocu.CodCia 
                cissac.CcbDDocu.CodDoc = cissac.CcbCDocu.CodDoc 
                cissac.CcbDDocu.NroDoc = cissac.CcbCDocu.NroDoc
                cissac.CcbDDocu.FchDoc = cissac.CcbCDocu.FchDoc
                cissac.CcbDDocu.CodDiv = cissac.CcbCDocu.CodDiv.
        END.
        ASSIGN
            cissac.CcbCDocu.SdoAct  = cissac.CcbCDocu.ImpTot
            cissac.CcbCDocu.Imptot2 = cissac.CcbCDocu.ImpTot.
        /* Control de Facturas */
        x-NroRf2 = x-NroRf2 + (IF x-NroRf2 = '' THEN '' ELSE ',') + cissac.CcbCDocu.NroDoc.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Genera-Guias) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Guias Procedure 
PROCEDURE Genera-Guias :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE iCountItem AS INTEGER INITIAL 1 NO-UNDO.
DEFINE VARIABLE lCreaHeader AS LOGICAL NO-UNDO.
DEFINE VARIABLE iCountGuide AS INTEGER NO-UNDO.
DEFINE VARIABLE lItemOk AS LOGICAL NO-UNDO.
DEFINE VARIABLE FILL-IN-items AS INTEGER NO-UNDO.
DEFINE VARIABLE x-NroDoc AS INTEGER NO-UNDO.

FIND cissac.FacCfgGn WHERE cissac.FacCfgGn.CodCia = s-CodCia NO-LOCK NO-ERROR.
FILL-IN-items = cissac.FacCfgGn.Items_Guias.

EMPTY TEMP-TABLE T-GUIAS.

trloop:
DO TRANSACTION ON ERROR UNDO trloop, RETURN ERROR ON STOP UNDO trloop, RETURN ERROR:
    FIND cissac.FacCorre WHERE cissac.FacCorre.CodCia = S-CODCIA 
        AND cissac.FacCorre.CodDoc = s-coddoc
        AND cissac.FacCorre.NroSer = COMBO-BOX-NroSerGR
        EXCLUSIVE-LOCK NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        MESSAGE 'NO se pudo bloquear el correlativo de' s-coddoc
            VIEW-AS ALERT-BOX ERROR TITLE 'G/R de CISSAC a CONTINENTAL'.
        UNDO trloop, RETURN ERROR.
    END.
    FIND cissac.FacCPedi WHERE ROWID(cissac.FacCPedi) = x-NroOD NO-LOCK.
    ASSIGN
        iCountGuide = 0
        lCreaHeader = TRUE
        lItemOk = FALSE.
    FOR EACH cissac.FacDPedi OF cissac.FacCPedi NO-LOCK,
        FIRST cissac.Almmmate WHERE cissac.Almmmate.CodCia = cissac.FacCPedi.CodCia 
        AND cissac.Almmmate.CodAlm = cissac.FacCPedi.CodAlm 
        AND cissac.Almmmate.CodMat = cissac.FacDPedi.CodMat
        BREAK BY cissac.Almmmate.CodUbi BY cissac.FacDPedi.CodMat:
        IF cissac.FacDPedi.CanPed > 0 THEN DO:
            /* Crea Cabecera */
            IF lCreaHeader THEN DO:
                /* Cabecera de Guía */
                ASSIGN
                    x-NroDoc = cissac.FacCorre.Correlativo.
                REPEAT:
                    IF NOT CAN-FIND(FIRST cissac.CcbCDocu WHERE cissac.CcbCDocu.CodCia = s-CodCia
                                    AND cissac.CcbCDocu.CodDiv = s-CodDiv
                                    AND cissac.CcbCDocu.CodDoc = s-CodDoc
                                    AND cissac.CcbCDocu.NroDoc = STRING(cissac.FacCorre.NroSer,"999") + STRING(x-NroDoc,"999999") 
                                    NO-LOCK)
                        THEN LEAVE.
                    x-NroDoc = x-NroDoc + 1.
                END.
                CREATE cissac.CcbCDocu.
                ASSIGN
                    cissac.CcbCDocu.CodCia = s-CodCia
                    cissac.CcbCDocu.CodDiv = s-CodDiv
                    cissac.CcbCDocu.CodDoc = s-CodDoc
                    cissac.CcbCDocu.NroDoc = STRING(cissac.FacCorre.NroSer,"999") + STRING(x-NroDoc,"999999") 
                    cissac.CcbCDocu.FchDoc = cissac.FacCPedi.FchPed
                    cissac.CcbCDocu.CodMov = 02     /* Salida por Ventas */
                    cissac.CcbCDocu.CodAlm = s-CodAlm
                    cissac.CcbCDocu.CodPed = cissac.FacCPedi.CodDoc 
                    cissac.CcbCDocu.NroPed = cissac.FacCPedi.NroPed
                    cissac.CcbCDocu.Tipo   = "OFICINA"
                    cissac.CcbCDocu.FchVto = TODAY
                    cissac.CcbCDocu.CodCli = cissac.FacCPedi.CodCli
                    cissac.CcbCDocu.NomCli = cissac.FacCPedi.NomCli
                    cissac.CcbCDocu.RucCli = cissac.FacCPedi.RucCli
                    cissac.CcbCDocu.DirCli = cissac.FacCPedi.DirCli
                    cissac.CcbCDocu.CodVen = cissac.FacCPedi.CodVen
                    cissac.CcbCDocu.TipVta = "2"
                    cissac.CcbCDocu.TpoFac = "R"       /* GUIA VENTA AUTOMATICA */
                    cissac.CcbCDocu.FmaPgo = cissac.FacCPedi.FmaPgo
                    cissac.CcbCDocu.CodMon = cissac.FacCPedi.CodMon
                    cissac.CcbCDocu.TpoCmb = cissac.FacCPedi.TpoCmb
                    cissac.CcbCDocu.PorIgv = cissac.FacCPedi.porIgv
                    cissac.CcbCDocu.NroOrd = cissac.FacCPedi.ordcmp
                    cissac.CcbCDocu.FlgEst = "F"       /* FACTURADO */
                    cissac.CcbCDocu.FlgSit = "P"
                    cissac.CcbCDocu.usuario = S-USER-ID
                    cissac.CcbCDocu.HorCie = STRING(TIME,'hh:mm')
                    cissac.CcbCDocu.FlgEnv = (cissac.FacCPedi.TpoPed = 'M')
                    /*cissac.CcbCDocu.CodAge = FILL-IN-CodAge
                    cissac.CcbCDocu.LugEnt = FILL-IN-LugEnt
                    cissac.CcbCDocu.Glosa = FILL-IN-Glosa*/
                    iCountGuide = iCountGuide + 1
                    lCreaHeader = FALSE.
                ASSIGN
                    cissac.FacCorre.Correlativo = x-NroDoc + 1.

                FIND cissac.gn-convt WHERE cissac.gn-convt.Codig = cissac.CcbCDocu.FmaPgo NO-LOCK NO-ERROR.
                IF AVAILABLE cissac.gn-convt THEN DO:
                    cissac.CcbCDocu.TipVta = IF cissac.gn-convt.TotDias = 0 THEN "1" ELSE "2".
                    cissac.CcbCDocu.FchVto = cissac.CcbCDocu.FchDoc + INTEGER(ENTRY(NUM-ENTRIES(cissac.gn-convt.Vencmtos),cissac.gn-convt.Vencmtos)).
                END.
                FIND cissac.gn-clie WHERE 
                    cissac.gn-clie.CodCia = cl-codcia AND
                    cissac.gn-clie.CodCli = cissac.CcbCDocu.CodCli 
                    NO-LOCK NO-ERROR.
                IF AVAILABLE cissac.gn-clie  THEN DO:
                    ASSIGN
                        cissac.CcbCDocu.CodDpto = cissac.gn-clie.CodDept 
                        cissac.CcbCDocu.CodProv = cissac.gn-clie.CodProv 
                        cissac.CcbCDocu.CodDist = cissac.gn-clie.CodDist.
                END.
            END.
            /* Crea Detalle */
            CREATE cissac.CcbDDocu.
            BUFFER-COPY cissac.FacDPedi 
                TO cissac.CcbDDocu
                ASSIGN
                cissac.CcbDDocu.CodCia = cissac.CcbCDocu.CodCia
                cissac.CcbDDocu.CodDiv = cissac.CcbCDocu.CodDiv
                cissac.CcbDDocu.Coddoc = cissac.CcbCDocu.Coddoc
                cissac.CcbDDocu.NroDoc = cissac.CcbCDocu.NroDoc 
                cissac.CcbDDocu.FchDoc = cissac.CcbCDocu.FchDoc
                cissac.CcbDDocu.AlmDes = cissac.CcbCDocu.CodAlm    /* OJO */
                cissac.CcbDDocu.CanDes = cissac.FacDPedi.CanPed.
            lItemOk = TRUE.
        END.
        iCountItem = iCountItem + 1.
        IF (iCountItem > FILL-IN-items OR LAST(cissac.FacDPedi.CodMat)) AND lItemOk THEN DO:
            RUN proc_GrabaTotales.
            IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO trloop, RETURN ERROR.
            /* Descarga de Almacen */
            /* Para no perder la variable s-codalm */
            RUN act_alm (ROWID(cissac.CcbCDocu)).
            IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO trloop, RETURN ERROR.
            /* Control de Guias de Remision */
            x-NroRf3 = x-NroRf3 + (IF x-NroRf3 = '' THEN '' ELSE ',') + cissac.CcbCDocu.NroDoc.
        END.
        IF iCountItem > FILL-IN-items THEN DO:
            iCountItem = 1.
            lCreaHeader = TRUE.
            lItemOk = FALSE.
        END.
    END. /* FOR EACH cissac.FacDPedi... */
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Genera-Ingreso-Almacen) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Ingreso-Almacen Procedure 
PROCEDURE Genera-Ingreso-Almacen :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* UN INGRESO POR CADA GUIA DE REMISION */
DEF VAR k AS INT NO-UNDO.
DEF VAR F-PesUnd AS DECIMAL NO-UNDO.
DEF VAR x-NroDoc AS INT NO-UNDO.
DEF VAR x-FechaD AS DATE NO-UNDO.
DEF VAR x-FechaH AS DATE NO-UNDO.

RUN src/bin/_dateif (COMBO-BOX-NroMes, COMBO-BOX-Periodo, OUTPUT x-FechaD, OUTPUT x-FechaH).
x-FechaH = x-FechaH + 1.
s-CodAlm = FILL-IN-AlmIng.

trloop:
DO TRANSACTION ON ERROR UNDO, RETURN ERROR ON STOP UNDO, RETURN ERROR:
    FIND integral.Almacen WHERE integral.Almacen.CodCia = S-CODCIA 
        AND integral.Almacen.CodAlm = s-CodAlm EXCLUSIVE-LOCK NO-ERROR.
    IF ERROR-STATUS:ERROR THEN UNDO, RETURN 'ADM-ERROR'.        
    FIND integral.gn-prov WHERE integral.gn-prov.CodCia = pv-codcia 
        AND integral.gn-prov.Codpro = integral.Lg-cocmp.codpro
        NO-LOCK NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        MESSAGE 'NO se pudo bloquear el correlativo de ingresos en el almacén' s-codalm
            VIEW-AS ALERT-BOX ERROR TITLE 'Ingresos por Almacén por Compras en CONTINENTAL'.
        UNDO, RETURN 'ADM-ERROR'.        
    END.
    FIND LAST integral.gn-tcmb NO-LOCK NO-ERROR.
    DO k = 1 TO NUM-ENTRIES(x-NroRf3):
        x-NroDoc = integral.Almacen.CorrIng.
        REPEAT:
            IF NOT CAN-FIND(integral.Almcmov WHERE integral.Almcmov.codcia = s-codcia
                            AND integral.Almcmov.codalm = s-codalm
                            AND integral.Almcmov.tipmov = 'I'
                            AND integral.Almcmov.codmov = 02
                            AND integral.Almcmov.nroser = 000
                            AND integral.Almcmov.nrodoc = x-NroDoc NO-LOCK)
                THEN LEAVE.
            x-NroDoc = x-NroDoc + 1.
        END.
        CREATE integral.Almcmov.
        ASSIGN 
            integral.Almcmov.CodCia  = s-CodCia 
            integral.Almcmov.CodAlm  = s-CodAlm 
            integral.Almcmov.TipMov  = "I"
            integral.Almcmov.CodMov  = 02
            integral.Almcmov.NroSer  = 000
            integral.Almcmov.NroDoc = x-NroDoc
            integral.Almcmov.FchDoc = x-FechaH
            integral.Almcmov.HorRcp  = STRING(TIME,"HH:MM:SS")
            integral.Almcmov.CodPro  = integral.Lg-cocmp.codpro
            integral.Almcmov.NomRef  = integral.gn-prov.nompro
            integral.Almcmov.CodMon  = integral.Lg-cocmp.codmon
            integral.Almcmov.TpoCmb  = integral.gn-tcmb.venta
            integral.Almcmov.NroRf1  = STRING(integral.LG-COCmp.NroDoc, '999999')
            integral.Almcmov.NroRf2  = ENTRY(k, x-NroRf2)
            integral.Almcmov.NroRf3  = ENTRY(k, x-NroRf3)
            integral.Almcmov.Observ  = integral.Lg-cocmp.Observaciones
            integral.Almcmov.ModAdq  = integral.Lg-cocmp.ModAdq.
        ASSIGN 
            integral.Almcmov.usuario = S-USER-ID
            integral.Almcmov.ImpIgv  = 0
            integral.Almcmov.ImpMn1  = 0
            integral.Almcmov.ImpMn2  = 0.
        ASSIGN
            integral.Almacen.CorrIng = x-NroDoc + 1.
        FOR EACH integral.Lg-docmp OF integral.Lg-cocmp,
            FIRST cissac.Ccbddocu WHERE cissac.Ccbddocu.codcia = s-codcia
            AND cissac.Ccbddocu.coddoc = "G/R"
            AND cissac.Ccbddocu.nrodoc = integral.Almcmov.NroRf3
            AND cissac.Ccbddocu.codmat = integral.Lg-docmp.codmat:
            CREATE integral.Almdmov.
            ASSIGN
                integral.Almdmov.CodCia = S-CODCIA
                integral.Almdmov.CodAlm = S-CODALM
                integral.Almdmov.TipMov = integral.Almcmov.TipMov 
                integral.Almdmov.CodMov = integral.Almcmov.CodMov 
                integral.Almdmov.NroSer = integral.Almcmov.NroSer 
                integral.Almdmov.NroDoc = integral.Almcmov.NroDoc 
                integral.Almdmov.CodMon = integral.Almcmov.CodMon 
                integral.Almdmov.FchDoc = integral.Almcmov.FchDoc 
                integral.Almdmov.TpoCmb = integral.Almcmov.TpoCmb
                integral.Almdmov.Codmat = integral.LG-DOCmp.Codmat 
                integral.Almdmov.CodUnd = integral.LG-DOCmp.UndCmp
                integral.Almdmov.CanDes = integral.LG-DOCmp.CanPedi
                integral.Almdmov.CanDev = integral.LG-DOCmp.CanPedi
                integral.Almdmov.PreLis = integral.LG-DOCmp.PreUni
                integral.Almdmov.Dsctos[1] = integral.LG-DOCmp.Dsctos[1]
                integral.Almdmov.Dsctos[2] = integral.LG-DOCmp.Dsctos[2]
                integral.Almdmov.Dsctos[3] = integral.LG-DOCmp.Dsctos[3]
                integral.Almdmov.IgvMat = integral.LG-DOCmp.IgvMat
                integral.Almdmov.PreUni = ROUND(integral.LG-DOCmp.PreUni * (1 - (integral.LG-DOCmp.Dsctos[1] / 100)) * 
                                                (1 - (integral.LG-DOCmp.Dsctos[2] / 100)) * 
                                                (1 - (integral.LG-DOCmp.Dsctos[3] / 100)),4)
                integral.Almdmov.ImpCto = ROUND(integral.Almdmov.CanDes * integral.Almdmov.PreUni,2)
                integral.Almdmov.CodAjt = 'A'
                integral.Almdmov.HraDoc = integral.Almcmov.HorRcp.
            FIND integral.Almmmatg WHERE integral.Almmmatg.CodCia = S-CODCIA 
                AND integral.Almmmatg.codmat = integral.Almdmov.codmat  
                NO-LOCK NO-ERROR.
            FIND integral.Almtconv WHERE integral.Almtconv.CodUnid = integral.Almmmatg.UndBas 
                AND integral.Almtconv.Codalter = integral.Almdmov.CodUnd 
                NO-LOCK NO-ERROR.
            integral.Almdmov.Factor = integral.Almtconv.Equival / integral.Almmmatg.FacEqu.
            IF NOT integral.Almmmatg.AftIgv THEN integral.Almdmov.IgvMat = 0.
            IF integral.Almcmov.codmon = 1 
                THEN integral.Almcmov.ImpMn1 = integral.Almcmov.ImpMn1 + integral.Almdmov.ImpMn1.
            ELSE integral.Almcmov.ImpMn2 = integral.Almcmov.ImpMn2 + integral.Almdmov.ImpMn2.
            /* *** */
/*             RUN ALMACSTK (ROWID(integral.Almdmov)).                                 */
/*             IF RETURN-VALUE = 'ADM-ERROR' THEN DO:                                  */
/*                 MESSAGE 'Problemas al actualizar el código' integral.Almdmov.codmat */
/*                     VIEW-AS ALERT-BOX ERROR.                                        */
/*                 UNDO trloop, RETURN 'ADM-ERROR'.                                    */
/*             END.                                                                    */
/*             RUN ALMACPR1-ING (ROWID(integral.Almdmov), "U").                        */
/*             IF RETURN-VALUE = 'ADM-ERROR' THEN DO:                                  */
/*                 MESSAGE 'Problemas al actualizar el código' integral.Almdmov.codmat */
/*                     VIEW-AS ALERT-BOX ERROR.                                        */
/*                 UNDO trloop, RETURN 'ADM-ERROR'.                                    */
/*             END.                                                                    */
        END.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Genera-Orden) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Orden Procedure 
PROCEDURE Genera-Orden :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-NroDoc AS INT NO-UNDO.

DO TRANSACTION ON ERROR UNDO, RETURN ERROR ON STOP UNDO, RETURN ERROR:
    FIND cissac.FacCorre WHERE cissac.FacCorre.CodCia = S-CODCIA 
        AND cissac.FacCorre.CodDoc = s-coddoc
        AND cissac.FacCorre.NroSer = COMBO-BOX-NroSerOD
        EXCLUSIVE-LOCK NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        MESSAGE 'NO se pudo bloquear el correlativo de' s-coddoc
            VIEW-AS ALERT-BOX ERROR TITLE 'Orden de Compra de CISSAC para Continental'.
        UNDO, RETURN ERROR.
    END.
    ASSIGN
        x-NroDoc = cissac.FacCorre.Correlativo.
    REPEAT:
        IF NOT CAN-FIND(FIRST cissac.FacCPedi WHERE cissac.FacCPedi.codcia = s-codcia
                        AND cissac.FacCPedi.coddiv = s-coddiv
                        AND cissac.FacCPedi.coddoc = s-coddoc
                        AND cissac.FacCPedi.nroped = STRING(cissac.FacCorre.NroSer,"999") + STRING(x-NroDoc,"999999")
                        NO-LOCK)
            THEN LEAVE.
        x-NroDoc = x-NroDoc + 1.
    END.
    FIND CPED WHERE ROWID(CPED) = x-NroPed NO-LOCK.
    CREATE cissac.FacCPedi.
    BUFFER-COPY CPED
        TO cissac.FacCPedi
        ASSIGN 
        cissac.FacCPedi.CodDoc = s-coddoc 
        cissac.FacCPedi.NroPed = STRING(cissac.FacCorre.NroSer,"999") + STRING(x-NroDoc,"999999")
        cissac.FacCPedi.FlgEst = "C"    /* CERRADA */
        cissac.FacCPedi.TpoPed = ""
        cissac.FacCPedi.TpoLic = YES
        cissac.FaccPedi.CodRef = CPED.CodDoc
        cissac.FaccPedi.NroRef = CPED.NroPed
        cissac.FacCPedi.Tipvta = "CON IGV".
    ASSIGN 
        cissac.FacCorre.Correlativo = x-NroDoc + 1.
    FOR EACH DPED OF CPED NO-LOCK:
        CREATE cissac.FacDPedi.
        BUFFER-COPY DPED
            TO cissac.FacDPedi
            ASSIGN 
            cissac.FacDPedi.CodCia = cissac.FacCPedi.CodCia
            cissac.FacDPedi.CodDiv = cissac.FacCPedi.CodDiv
            cissac.FacDPedi.coddoc = cissac.FacCPedi.coddoc
            cissac.FacDPedi.NroPed = cissac.FacCPedi.NroPed
            cissac.FacDPedi.FchPed = cissac.FacCPedi.FchPed
            cissac.FacDPedi.Hora   = cissac.FacCPedi.Hora 
            cissac.FacDPedi.FlgEst = cissac.FacCPedi.FlgEst.
        ASSIGN
            cissac.FacDPedi.CanAte  = cissac.FacDPedi.CanPed    /* OJO */
            cissac.FacDPedi.CanPick = cissac.FacDPedi.CanPed.
    END.
    x-NroOD = ROWID(cissac.FacCPedi).
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Genera-Pedido) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Pedido Procedure 
PROCEDURE Genera-Pedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-NroDoc AS INT NO-UNDO.

DO TRANSACTION ON ERROR UNDO, RETURN ERROR ON STOP UNDO, RETURN ERROR:
    FIND cissac.FacCorre WHERE cissac.FacCorre.CodCia = S-CODCIA 
        AND cissac.FacCorre.CodDoc = s-coddoc
        AND cissac.FacCorre.NroSer = COMBO-BOX-NroSerPed
        EXCLUSIVE-LOCK NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        MESSAGE 'NO se pudo bloquear el correlativo del' s-coddoc
            VIEW-AS ALERT-BOX ERROR TITLE 'Pedido de Venta CISSAC a CONTINENTAL'.
        UNDO, RETURN ERROR.
    END.
    ASSIGN
        x-NroDoc = cissac.FacCorre.Correlativo.
    REPEAT:
        IF NOT CAN-FIND(FIRST cissac.FacCPedi WHERE cissac.FacCPedi.codcia = s-codcia
                        AND cissac.FacCPedi.coddiv = s-coddiv
                        AND cissac.FacCPedi.coddoc = s-coddoc
                        AND cissac.FacCPedi.nroped = STRING(cissac.FacCorre.NroSer,"999") + STRING(x-NroDoc,"999999")
                        NO-LOCK)
            THEN LEAVE.
        x-NroDoc = x-NroDoc + 1.
    END.
    FIND CCOT WHERE ROWID(CCOT) = x-NroCot NO-LOCK.
    CREATE cissac.FacCPedi.
    BUFFER-COPY CCOT
        TO cissac.FacCPedi
        ASSIGN 
        cissac.FacCPedi.CodDoc = s-coddoc 
        cissac.FacCPedi.NroPed = STRING(cissac.FacCorre.NroSer,"999") + STRING(x-NroDoc,"999999")
        cissac.FacCPedi.FlgEst = "C"    /* Cerrada */
        cissac.FacCPedi.TpoPed = ""
        cissac.FaccPedi.CodRef = CCOT.CodDoc
        cissac.FaccPedi.NroRef = CCOT.NroPed.
    ASSIGN 
        cissac.FacCorre.Correlativo = x-NroDoc + 1.
    FOR EACH DCOT OF CCOT NO-LOCK:
        CREATE cissac.FacDPedi.
        BUFFER-COPY DCOT
            TO cissac.FacDPedi
            ASSIGN 
            cissac.FacDPedi.CodCia = cissac.FacCPedi.CodCia
            cissac.FacDPedi.CodDiv = cissac.FacCPedi.CodDiv
            cissac.FacDPedi.coddoc = cissac.FacCPedi.coddoc
            cissac.FacDPedi.NroPed = cissac.FacCPedi.NroPed
            cissac.FacDPedi.FlgEst = cissac.FacCPedi.FlgEst.
        ASSIGN
            cissac.FacDPedi.CanAte = cissac.FacDPedi.CanPed.    /* OJO */
    END.
    x-NroPed = ROWID(cissac.FacCPedi).
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Genera-Venta-Cissac-Conti) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Venta-Cissac-Conti Procedure 
PROCEDURE Genera-Venta-Cissac-Conti :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FIND integral.Lg-cocmp WHERE ROWID(integral.Lg-cocmp) = pRowid EXCLUSIVE-LOCK NO-ERROR.
    IF ERROR-STATUS:ERROR THEN UNDO, RETURN 'ADM-ERROR'.
    ASSIGN
        integral.Lg-cocmp.flgsit = "T".
    FIND cissac.gn-clie WHERE cissac.gn-clie.CodCia = cl-codcia 
        AND cissac.gn-clie.CodCli = "20100038146"   /* Continental SAC */
        NO-LOCK NO-ERROR.
    /* 1ro. Generación de Cotización */
    s-coddoc = "COT".
    RUN Genera-Cotizacion NO-ERROR.
    IF ERROR-STATUS:ERROR THEN UNDO, RETURN 'ADM-ERROR'.
    /* 2do. Generación de Pedido */
    s-coddoc = "PED".
    RUN Genera-Pedido NO-ERROR.
    IF ERROR-STATUS:ERROR THEN UNDO, RETURN 'ADM-ERROR'.
    /* 3ro. Generación Orden de Despacho */
    s-coddoc = "O/D".
    RUN Genera-Orden NO-ERROR.
    IF ERROR-STATUS:ERROR THEN UNDO, RETURN 'ADM-ERROR'.
    /* 4to. Generación Guias */
    s-coddoc = "G/R".
    RUN Genera-Guias NO-ERROR.
    IF ERROR-STATUS:ERROR THEN UNDO, RETURN 'ADM-ERROR'.
    /* 5to. Generación Facturas */
    s-coddoc = "FAC".
    RUN Genera-Facturas NO-ERROR.
    IF ERROR-STATUS:ERROR THEN UNDO, RETURN 'ADM-ERROR'.
    /* 6to. Ingreso al Almacén */
    RUN Genera-Ingreso-Almacen NO-ERROR.
    IF ERROR-STATUS:ERROR THEN UNDO, RETURN 'ADM-ERROR'.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Orden-de-Compra-Conti-a-Cissac) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Orden-de-Compra-Conti-a-Cissac Procedure 
PROCEDURE Orden-de-Compra-Conti-a-Cissac :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* CARGAMOS EL DETALLE */
DEF VAR F-FACTOR AS DEC NO-UNDO.
DEF VAR s-codmon AS INT INIT 2 NO-UNDO.     /* US$ */
DEF VAR S-TPOCMB  AS DEC INIT 1 NO-UNDO.
DEF VAR x-FechaD AS DATE NO-UNDO.
DEF VAR x-FechaH AS DATE NO-UNDO.
DEF VAR x-Importe LIKE integral.Lg-docmp.preuni NO-UNDO.
DEF VAR x-CuentaItems AS INT NO-UNDO.

FIND LAST integral.gn-tcmb WHERE integral.gn-tcmb.FECHA <= x-FechaH NO-LOCK NO-ERROR.
IF AVAILABLE integral.gn-tcmb THEN S-TPOCMB = integral.gn-tcmb.compra.

/* CARGAMOS EL TEMPORAL DE COMPRAS */
EMPTY TEMP-TABLE DCMP.
FOR EACH RDOCU WHERE RDOCU.CanDev > 0:
    CREATE DCMP.
    ASSIGN
        DCMP.CodCia  = s-codcia
        DCMP.Codmat  = RDOCU.codmat
        DCMP.CanPedi = RDOCU.CanDev
        DCMP.UndCmp  = RDOCU.UndVta.
    FIND integral.Almmmatg WHERE integral.Almmmatg.CodCia = S-CODCIA 
        AND integral.Almmmatg.CodMat = DCMP.CodMat
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE integral.Almmmatg THEN DO:
        MESSAGE "Articulo" DCMP.codmat "NO registrado en el catálogo" 
            VIEW-AS ALERT-BOX WARNING TITLE "O/C DE CONTINENTAL A CISSAC".
        DELETE DCMP.
        NEXT.
    END.
    IF integral.Almmmatg.Tpoart <> "A" THEN DO:
        MESSAGE "Articulo" DCMP.codmat "Desactivado" 
            VIEW-AS ALERT-BOX WARNING  TITLE "O/C DE CONTINENTAL A CISSAC".
        DELETE DCMP.
        NEXT.
    END.
    F-FACTOR = 1.
    FIND integral.Almtconv WHERE integral.Almtconv.CodUnid = integral.Almmmatg.UndBas
        AND  integral.Almtconv.Codalter = integral.Almmmatg.UndCmp
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE integral.Almtconv THEN DO:
        MESSAGE "Tabla de equivalencias NO definida para:" SKIP
            "Artículo:" integral.Almmmatg.codmat SKIP
            "Unidad base:" integral.Almmmatg.undbas SKIP
            "Unidad de compra:" integral.Almmmatg.undcmp
            VIEW-AS ALERT-BOX WARNING  TITLE "O/C DE CONTINENTAL A CISSAC".
        DELETE DCMP.
        NEXT.
    END.
    ELSE F-FACTOR = integral.Almtconv.Equival.
    /***** Se Usara con lista de Precios Proveedor Original *****/
    FIND integral.lg-dmatpr WHERE integral.lg-dmatpr.codcia = s-codcia
        AND integral.lg-dmatpr.codmat = DCMP.codmat
        AND CAN-FIND(FIRST integral.lg-cmatpr WHERE integral.lg-cmatpr.codcia = s-codcia
                     AND integral.lg-cmatpr.nrolis = integral.lg-dmatpr.nrolis
                     AND integral.lg-cmatpr.codpro = "51135890"     /* Standford */
                     AND integral.lg-cmatpr.flgest = 'A' NO-LOCK)
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE integral.lg-dmatpr THEN DO:
        MESSAGE "Articulo" DCMP.codmat "NO está asignado al proveedor" 
            VIEW-AS ALERT-BOX WARNING TITLE "O/C DE CONTINENTAL A CISSAC".
        DELETE DCMP.
        NEXT.
    END.
    IF AVAILABLE integral.lg-dmatpr THEN DO:
        ASSIGN
            DCMP.Dsctos[1] = integral.lg-dmatpr.Dsctos[1]
            DCMP.Dsctos[2] = integral.lg-dmatpr.Dsctos[2]
            DCMP.Dsctos[3] = integral.lg-dmatpr.Dsctos[3]
            DCMP.IgvMat    = integral.lg-dmatpr.IgvMat.
        IF S-CODMON = 1 THEN DO:
            IF integral.lg-dmatpr.CodMon = 1 THEN DCMP.PreUni = integral.lg-dmatpr.PreAct.
            ELSE DCMP.PreUni = ROUND(integral.lg-dmatpr.PreAct * S-TPOCMB,4).
        END.
        ELSE DO:
            IF integral.lg-dmatpr.CodMon = 2 THEN DCMP.PreUni = integral.lg-dmatpr.PreAct.
            ELSE DCMP.PreUni = ROUND(integral.lg-dmatpr.PreAct / S-TPOCMB,4).
        END.
    END.
    
    ASSIGN 
        DCMP.CodCia = S-CODCIA 
        DCMP.UndCmp = integral.Almmmatg.UndStk
        DCMP.ArtPro = integral.Almmmatg.ArtPro
        /*DCmp.CanAten = S-Codmon*/
        x-Importe = DCmp.CanPedi * DCMP.PreUni
        DCMP.ImpTot = ROUND(x-Importe * 
                            (1 - (DCMP.Dsctos[1] / 100)) *
                            (1 - (DCMP.Dsctos[2] / 100)) *
                            (1 - (DCMP.Dsctos[3] / 100)) *
                            (1 + (DCMP.IgvMat / 100)), 2).

END.

/* GENERAMOS LA O/C */
DEFINE VARIABLE X-NRODOC AS INTEGER NO-UNDO.
DEFINE VARIABLE f-ImpTot AS DEC NO-UNDO.
DEFINE VARIABLE iNroRef  AS INTEGER     NO-UNDO.

RUN src/bin/_dateif (COMBO-BOX-NroMes, COMBO-BOX-Periodo, OUTPUT x-FechaD, OUTPUT x-FechaH).
x-FechaH = x-FechaH + 1.
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FIND integral.LG-CORR WHERE integral.LG-CORR.CodCia = S-CODCIA 
        AND integral.LG-CORR.CodDiv = "00000"
        AND  integral.LG-CORR.CodDoc = "O/C" 
        EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE integral.LG-CORR THEN DO:
        MESSAGE 'NO se pudo bloquear el correlativo de O/C'
            VIEW-AS ALERT-BOX ERROR TITLE "O/C DE CONTINENTAL A CISSAC".
        UNDO, RETURN 'ADM-ERROR'.
    END.
        
    ASSIGN
        X-NRODOC = integral.LG-CORR.NroDoc.
    REPEAT:
        IF NOT CAN-FIND(FIRST integral.LG-COCmp WHERE integral.LG-COCmp.CodCia = S-CODCIA
                        AND integral.LG-COCmp.CodDiv = "00000"
                        AND integral.LG-COCmp.TpoDoc = "N"
                        AND integral.LG-COCmp.NroDoc = X-NRODOC
                        NO-LOCK)
            THEN LEAVE.
        x-NroDoc = x-NroDoc + 1.
    END.
    CREATE integral.LG-COCmp.
    ASSIGN 
        integral.LG-COCmp.CodCia = S-CODCIA
        integral.LG-COCmp.CodDiv = "00000"
        integral.LG-COCmp.TpoDoc = "N"
        integral.LG-COCmp.NroDoc = X-NRODOC
        integral.LG-COCmp.FchDoc = x-FechaH
        integral.LG-COCmp.FchVto = x-FechaH
        integral.LG-COCmp.FchEnt = x-FechaH
        integral.LG-COCmp.CodPro = "51135890"
        integral.LG-COCmp.CndCmp = "160"
        integral.LG-COCmp.CodMon = s-CodMon
        integral.LG-COCmp.TpoCmb = s-TpoCmb
        integral.LG-COCmp.Cco    = "F9"
        integral.LG-COCmp.CodAlm = "21"
        integral.LG-COCmp.FlgSit = "G" 
        /*integral.LG-COCmp.NroReq = I-NROREQ*/
        integral.LG-COCmp.Userid-com = S-USER-ID
        integral.LG-COCmp.Libre_c01 = STRING(COMBO-BOX-Periodo, '9999') + STRING(COMBO-BOX-nroMes, '99')
        integral.LG-COCmp.Libre_c02 = "DEVCOCI".

    ASSIGN
        integral.LG-CORR.NroDoc = x-NroDoc + 1.

    FIND integral.gn-prov WHERE integral.gn-prov.CodCia = PV-CODCIA 
        AND  integral.gn-prov.CodPro = integral.LG-COCmp.CodPro 
        NO-LOCK NO-ERROR.
    IF AVAILABLE integral.gn-prov THEN ASSIGN integral.LG-COCmp.NomPro = integral.gn-prov.NomPro.

    FOR EACH DCMP:
        CREATE integral.Lg-docmp.
        ASSIGN 
            integral.Lg-docmp.CodCia = integral.LG-COCmp.CodCia 
            integral.Lg-docmp.CodDiv = integral.LG-COCmp.CodDiv
            integral.Lg-docmp.TpoDoc = integral.LG-COCmp.TpoDoc 
            integral.Lg-docmp.NroDoc = integral.LG-COCmp.NroDoc 
            integral.Lg-docmp.tpobien = DCMP.TpoBien
            integral.Lg-docmp.Codmat = DCMP.Codmat 
            integral.Lg-docmp.ArtPro = DCMP.ArtPro 
            integral.Lg-docmp.UndCmp = DCMP.UndCmp
            integral.Lg-docmp.CanPedi = DCMP.CanPedi 
            integral.Lg-docmp.Dsctos[1] = DCMP.Dsctos[1] 
            integral.Lg-docmp.Dsctos[2] = DCMP.Dsctos[2] 
            integral.Lg-docmp.Dsctos[3] = DCMP.Dsctos[3] 
            integral.Lg-docmp.IgvMat = DCMP.IgvMat 
            integral.Lg-docmp.ImpTot = DCMP.ImpTot 
            integral.Lg-docmp.PreUni = DCMP.PreUni.
    END.
    ASSIGN 
        integral.LG-COCmp.ImpTot = 0
        integral.LG-COCmp.ImpExo = 0.
    FOR EACH integral.Lg-docmp OF integral.LG-COCmp NO-LOCK:
        integral.LG-COCmp.ImpTot = integral.LG-COCmp.ImpTot + integral.Lg-docmp.ImpTot.
        IF integral.Lg-docmp.IgvMat = 0 THEN integral.LG-COCmp.ImpExo = integral.LG-COCmp.ImpExo + integral.Lg-docmp.ImpTot.
    END.
    FIND LAST integral.LG-CFGIGV NO-LOCK NO-ERROR.
    ASSIGN 
        integral.LG-COCmp.ImpIgv = (integral.LG-COCmp.ImpTot - integral.LG-COCmp.ImpExo) - 
        ROUND((integral.LG-COCmp.ImpTot - integral.LG-COCmp.ImpExo) / (1 + integral.LG-CFGIGV.PorIgv / 100),2)
        integral.LG-COCmp.ImpBrt = integral.LG-COCmp.ImpTot - integral.LG-COCmp.ImpExo - integral.LG-COCmp.ImpIgv
        integral.LG-COCmp.ImpDto = 0
        integral.LG-COCmp.ImpNet = integral.LG-COCmp.ImpBrt - integral.LG-COCmp.ImpDto.
    /* Busca Serie Documento */
    FOR EACH CCMP WHERE CCMP.CodCia = s-codcia
        AND CCMP.NroRef <> '' NO-LOCK 
        BREAK BY CCMP.NroRef : 
        IF CCMP.NroDoc = integral.LG-COCmp.NroDoc THEN iNroRef = INT(CCMP.NroRef).
        ELSE iNroRef = INT(CCMP.NroRef) + 1.      
    END.
    IF iNroRef = 0 THEN iNroRef = iNroRef + 1.
    integral.LG-COCmp.NroRef = STRING(iNroRef,"999999").
    /* CONTROL DE O/C */
    pRowid = ROWID(integral.Lg-cocmp).
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-proc_GrabaTotales) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_GrabaTotales Procedure 
PROCEDURE proc_GrabaTotales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE dIGV AS DECIMAL NO-UNDO.
    DEFINE VARIABLE dISC AS DECIMAL NO-UNDO.

    DEFINE BUFFER b-CDocu FOR cissac.CcbCDocu.
    DEFINE BUFFER b-DDocu FOR cissac.CcbDDocu.

    DO ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN 'ADM-ERROR':
        FIND b-CDocu WHERE ROWID(b-CDocu) = ROWID(cissac.CcbCDocu) EXCLUSIVE-LOCK NO-ERROR.
        b-CDocu.ImpDto = 0.
        b-CDocu.ImpIgv = 0.
        b-CDocu.ImpIsc = 0.
        b-CDocu.ImpTot = 0.
        b-CDocu.ImpExo = 0.
        FOR EACH b-DDocu OF b-CDocu NO-LOCK:
            dIGV = dIGV + b-DDocu.ImpIgv.
            dISC = dISC + b-DDocu.ImpIsc.
            b-CDocu.ImpTot = b-CDocu.ImpTot + b-DDocu.ImpLin.
            IF NOT b-DDocu.AftIgv THEN b-CDocu.ImpExo = b-CDocu.ImpExo + b-DDocu.ImpLin.
            IF b-DDocu.AftIgv THEN
                b-CDocu.ImpDto = b-CDocu.ImpDto +
                    ROUND(b-DDocu.ImpDto / (1 + b-CDocu.PorIgv / 100),2).
            ELSE b-CDocu.ImpDto = b-CDocu.ImpDto + b-DDocu.ImpDto.
        END.
        b-CDocu.ImpIgv = ROUND(dIGV,2).
        b-CDocu.ImpIsc = ROUND(dISC,2).
        b-CDocu.ImpVta = b-CDocu.ImpTot - b-CDocu.ImpExo - b-CDocu.ImpIgv.
        IF b-CDocu.PorDto > 0 THEN DO:
            b-CDocu.ImpDto = b-CDocu.ImpDto +
                ROUND((b-CDocu.ImpVta + b-CDocu.ImpExo) * b-CDocu.PorDto / 100,2).
            b-CDocu.ImpTot = ROUND(b-CDocu.ImpTot * (1 - b-CDocu.PorDto / 100),2).
            b-CDocu.ImpVta = ROUND(b-CDocu.ImpVta * (1 - b-CDocu.PorDto / 100),2).
            b-CDocu.ImpExo = ROUND(b-CDocu.ImpExo * (1 - b-CDocu.PorDto / 100),2).
            b-CDocu.ImpIgv = b-CDocu.ImpTot - b-CDocu.ImpExo - b-CDocu.ImpVta.
        END.
        b-CDocu.ImpBrt = b-CDocu.ImpVta + b-CDocu.ImpIsc + b-CDocu.ImpDto + b-CDocu.ImpExo.
        b-CDocu.SdoAct = b-CDocu.ImpTot.
        CREATE T-GUIAS.
        BUFFER-COPY b-CDocu TO T-GUIAS.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

