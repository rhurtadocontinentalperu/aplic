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
DEFINE INPUT PARAMETER D-ROWID AS ROWID.

DEF NEW SHARED TEMP-TABLE T-CcbDDocu LIKE CcbDDocu.
DEF NEW SHARED TEMP-TABLE T-CcbCCaja LIKE CcbCCaja.

DEF NEW SHARED VAR F-coddoc AS CHAR INITIAL "FAC".
DEF NEW SHARED VAR s-codcja AS CHAR INITIAL "I/C".
DEF NEW SHARED VAR s-ptovta AS INT.
DEF NEW SHARED VAR s-sercja AS INT.
DEF NEW SHARED VAR s-tipo   AS CHAR INITIAL "MOSTRADOR".
DEF NEW SHARED VAR s-codmov LIKE Almtmovm.Codmov.
DEF NEW SHARED VAR s-codalm LIKE almacen.codalm.
DEF NEW SHARED VAR s-codter LIKE ccbcterm.codter INITIAL 'Caja01'.
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-coddiv LIKE gn-divi.coddiv.
DEF SHARED VAR s-user-id AS CHAR.

DEFINE VARIABLE C-MON AS CHAR NO-UNDO.
DEFINE VARIABLE C-HOR AS CHAR NO-UNDO.
DEFINE VARIABLE L-OK  AS LOGICAL NO-UNDO.

DEFINE BUFFER B-PedM FOR FacCPedm.
DEFINE BUFFER B-CDocu FOR CcbCDocu.

  /* Control del documento Ingreso Caja por terminal */
  FIND FIRST ccbdterm WHERE CcbDTerm.CodCia = s-codcia AND
       CcbDTerm.CodDiv = s-coddiv AND
       CcbDTerm.CodDoc = s-codcja AND
       CcbDTerm.CodTer = s-codter NO-LOCK NO-ERROR.
  IF NOT AVAILABLE ccbdterm
  THEN DO:
      MESSAGE "EL Documento de Caja no sta configurada en este terminal" VIEW-AS ALERT-BOX ERROR.
      RETURN "ADM-ERROR".
  END.
  s-sercja = ccbdterm.nroser.
  /* Control de documentos Factura/Boleta por terminal */
  FIND FIRST ccbdterm WHERE CcbDTerm.CodCia = s-codcia AND
      CcbDTerm.CodDiv = s-coddiv AND
      CcbDTerm.CodDoc = F-coddoc AND
      CcbDTerm.CodTer = s-codter NO-LOCK NO-ERROR.
  IF NOT AVAILABLE ccbdterm
  THEN DO:
      MESSAGE "La factura no esta configurada en este terminal" VIEW-AS ALERT-BOX ERROR.
      RETURN "ADM-ERROR".
  END.
  s-ptovta = ccbdterm.nroser.
  FIND FIRST ccbdterm WHERE CcbDTerm.CodCia = s-codcia AND
      CcbDTerm.CodDiv = s-coddiv AND
      CcbDTerm.CodDoc = "BOL" AND
      CcbDTerm.CodTer = s-codter NO-LOCK NO-ERROR.
  IF NOT AVAILABLE ccbdterm
  THEN DO:
      MESSAGE "La Boleta no esta configurada en este terminal" VIEW-AS ALERT-BOX ERROR.
      RETURN "ADM-ERROR".
  END.
  
  /* Control de correlativos */
  FIND FacDocum WHERE facdocum.codcia = s-codcia AND facdocum.coddoc = F-coddoc
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE FacDocum
  THEN DO:
      MESSAGE "No esta definido el documento" F-coddoc VIEW-AS ALERT-BOX ERROR.
      RETURN "ADM-ERROR".
  END.
  s-codmov = facdocum.codmov.
  FIND almtmovm WHERE Almtmovm.CodCia = s-codcia AND
      Almtmovm.Codmov = s-codmov AND Almtmovm.Tipmov = "S" NO-LOCK NO-ERROR.
  IF NOT AVAILABLE almtmovm
  THEN DO:
      MESSAGE "No esta definido el movimiento de salida" s-codmov VIEW-AS ALERT-BOX ERROR.
      RETURN "ADM-ERROR".
  END.
  FIND FacCorre WHERE faccorre.codcia = s-codcia AND faccorre.coddoc = F-coddoc AND
      faccorre.nroser = s-ptovta NO-LOCK NO-ERROR.
  IF NOT AVAILABLE FacCorre
  THEN DO:
      MESSAGE "No esta definida la serie" s-ptovta SKIP
          "para las facturas mostrador" VIEW-AS ALERT-BOX ERROR.
      RETURN "ADM-ERROR".
  END.
  s-codalm = faccorre.codalm.

/* Definicion de variables compartidas */
DEFINE VARIABLE input-var-1  AS CHARACTER.
DEFINE VARIABLE input-var-2  AS CHARACTER.
DEFINE VARIABLE input-var-3  AS CHARACTER.
DEFINE VARIABLE output-var-1 AS ROWID.
DEFINE VARIABLE output-var-2 AS CHARACTER.
DEFINE VARIABLE output-var-3 AS CHARACTER.

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

  FIND B-PedM WHERE ROWID(B-PedM) = D-ROWID NO-LOCK NO-ERROR. 
  
  RUN ccb\Canc_Ped ( D-ROWID, OUTPUT L-OK).
 
  IF L-OK = NO THEN RETURN "ADM-ERROR".
  
  F-CODDOC = B-PedM.Cmpbnte.
  
  DO TRANSACTION ON ERROR UNDO, RETURN ERROR:
     RUN Captura-Configuracion.
     
     FIND B-PedM WHERE ROWID(B-PedM) = D-ROWID EXCLUSIVE-LOCK . 
     s-codalm = B-PedM.codalm.   /* << OJO << lo tomamos del pedido */
     
     CREATE CcbCDocu.
     FIND faccorre WHERE 
          faccorre.codcia = s-codcia AND 
          faccorre.coddoc = F-coddoc AND
          faccorre.NroSer = s-ptovta EXCLUSIVE-LOCK NO-ERROR.
     IF AVAILABLE faccorre THEN 
        ASSIGN
             ccbcdocu.nrodoc = STRING(faccorre.nroser, "999") + STRING(FacCorre.Correlativo, "999999")
             faccorre.correlativo = faccorre.correlativo + 1.
     RELEASE faccorre.
     ASSIGN 
        CcbCDocu.CodCia = s-codcia
        CcbCDocu.CodDoc = F-coddoc
        CcbCDocu.usuario= s-user-id
        CcbCDocu.usrdscto = B-PedM.usrdscto 
        CcbCDocu.Tipo   = s-tipo
        CcbCDocu.CodAlm = s-codalm
        CcbCDocu.CodDiv = s-coddiv
        CcbCDocu.CodCli = B-PedM.Codcli
        CcbCDocu.RucCli = B-PedM.RucCli
        CcbCDocu.NomCli = B-PedM.Nomcli
        CcbCDocu.DirCli = B-PedM.DirCli
        CcbCDocu.CodMon = B-PedM.codmon
        CcbCDocu.CodMov = s-codmov
        CcbCDocu.CodPed = B-PedM.coddoc
        CcbCDocu.CodVen = B-PedM.codven
        CcbCDocu.FchCan = TODAY
        CcbCDocu.FchDoc = TODAY
        CcbCDocu.FchVto = TODAY
        CcbCDocu.ImpBrt = B-PedM.impbrt
        CcbCDocu.ImpDto = B-PedM.impdto
        CcbCDocu.ImpExo = B-PedM.impexo
        CcbCDocu.ImpIgv = B-PedM.impigv
        CcbCDocu.ImpIsc = B-PedM.impisc
        CcbCDocu.ImpTot = B-PedM.imptot
        CcbCDocu.ImpVta = B-PedM.impvta
        CcbCDocu.TipVta = "1"
        CcbCDocu.TpoFac = "C"
        CcbCDocu.FmaPgo = "000"
        CcbCDocu.NroPed = B-PedM.nroped
        CcbCDocu.PorIgv = B-PedM.porigv 
        CcbCDocu.SdoAct = B-PedM.imptot
        CcbCDocu.TpoCmb = B-PedM.tpocmb.
        /* POR AHORA GRABAMOS EL TIPO DE ENTREGA */
        CcbCDocu.CodAge =  B-PedM.CodTrans.
        CcbCDocu.FlgSit =  "P".
        CcbCDocu.FlgAte =  "P".
        CcbCDocu.FlgCon =  IF B-PedM.DocDesp = "GUIA" THEN "G" ELSE "".
       
      /* ACTUALIZAMOS EL PEDIDO  DE MOSTRADOR */
      ASSIGN  B-PedM.flgest = "C".
      
      /* actualizamos el detalle */
      DEF VAR i AS INTEGER INITIAL 1 NO-UNDO.
      FOR EACH facdpedm OF B-PedM BY nroitm:
          CREATE ccbDDocu.
          ASSIGN
              CcbDDocu.CodCia = ccbcdocu.codcia
              CcbDDocu.CodDoc = ccbcdocu.coddoc
              CcbDDocu.NroDoc = ccbcdocu.nrodoc
              CcbDDocu.codmat = facdpedm.codmat
              CcbDDocu.Factor = facdpedm.factor
              CcbDDocu.ImpDto = facdpedm.impdto
              CcbDDocu.ImpIgv = facdpedm.impigv
              CcbDDocu.ImpIsc = facdpedm.impisc
              CcbDDocu.ImpLin = facdpedm.implin
              CcbDDocu.AftIgv = facdpedm.aftigv
              CcbDDocu.AftIsc = facdpedm.aftisc
              CcbDDocu.CanDes = facdpedm.canped
              CcbDDocu.NroItm = i
              CcbDDocu.PorDto = facdpedm.pordto
              CcbDDocu.PreBas = facdpedm.prebas
              CcbDDocu.PreUni = facdpedm.preuni
              CcbDDocu.PreVta[1] = facdpedm.prevta[1]
              CcbDDocu.PreVta[2] = facdpedm.prevta[2]
              CcbDDocu.PreVta[3] = facdpedm.prevta[3]
              CcbDDocu.UndVta = facdpedm.undvta
              i = i + 1.
      END.
      RELEASE B-PedM.
      
      /* Cancelacion del documento */
      RUN Ingreso-a-Caja.
  END.

  IF CcbCDocu.Flgcon = 'G' THEN DO:
     RUN Genera-Guia-Remision.
  END.

  IF AVAILABLE CcbCDocu THEN  DO:
     CASE Ccbcdocu.CodDoc:
            WHEN "FAC" THEN 
                  RUN ccb/r-fact01 (ROWID(ccbcdocu)).
            WHEN "BOL" THEN      
                  RUN ccb/r-bole01 (ROWID(ccbcdocu)).
     END CASE.                  
  END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Cancelar-Documento Procedure 
PROCEDURE Cancelar-Documento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FIND B-CDocu WHERE B-CDocu.CodCia = s-codcia AND
       B-CDocu.CodDoc = 'N/C' AND B-CDocu.NroDoc = T-CcbCCaja.Voucher[6] NO-LOCK NO-ERROR.
  IF NOT AVAILABLE B-CDocu THEN DO:
     MESSAGE 'Nota de Credito no se encuentra registrada' VIEW-AS ALERT-BOX ERROR.
     RETURN "ADM-ERROR".
  END.
  CREATE CcbDCaja.
  ASSIGN 
     CcbDCaja.CodCia = s-CodCia
     CcbDCaja.CodDoc = 'N/C'
     CcbDCaja.NroDoc = T-CcbCCaja.Voucher[6]
     CcbDCaja.CodMon = B-CDocu.CodMon
     CcbDCaja.TpoCmb = CcbCDocu.tpocmb
     CcbDCaja.CodCli = CcbCDocu.CodCli
     CcbDCaja.CodRef = B-CDocu.CodDoc
     CcbDCaja.NroRef = B-CDocu.NroDoc
     CcbDCaja.FchDoc = CcbCDocu.FchDoc.
  IF B-CDocu.CodMon = 1 THEN
     ASSIGN 
        CcbDCaja.ImpTot = T-CcbCCaja.ImpNac[6].
  ELSE
     ASSIGN 
        CcbDCaja.ImpTot = T-CcbCCaja.ImpUsa[6].

  RUN Cancelar_Nota_Credito ( s-CodCia, CcbDCaja.CodRef, CcbDCaja.NroRef, CcbDCaja.CodMon,
                              CcbDCaja.TpoCmb, CcbDCaja.ImpTot, FALSE ).
  RUN Cancelar_Nota_Credito ( s-CodCia, CcbDCaja.CodDoc, CcbDCaja.NroDoc, CcbDCaja.CodMon,
                              CcbDCaja.TpoCmb, CcbDCaja.ImpTot, FALSE ).    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Captura-Configuracion Procedure 
PROCEDURE Captura-Configuracion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  /* Saca la Serie Factura/Boleta por terminal */
  FIND FIRST ccbdterm WHERE CcbDTerm.CodCia = s-codcia AND
       CcbDTerm.CodDiv = s-coddiv AND
       CcbDTerm.CodDoc = F-coddoc AND
       CcbDTerm.CodTer = s-codter NO-LOCK NO-ERROR.
       s-ptovta = ccbdterm.nroser.
       
  /* Control de correlativos */
  FIND FacDocum WHERE facdocum.codcia = s-codcia AND facdocum.coddoc = F-coddoc
      NO-LOCK NO-ERROR.
  s-codmov = facdocum.codmov.
  FIND FacCorre WHERE faccorre.codcia = s-codcia AND faccorre.coddoc = F-coddoc AND
      faccorre.nroser = s-ptovta NO-LOCK NO-ERROR.
  s-codalm = faccorre.codalm.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Guia-Remision Procedure 
PROCEDURE Genera-Guia-Remision :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
     F-CODDOC = 'G/R'.
     DO TRANSACTION ON ERROR UNDO, RETURN ERROR:
        RUN Captura-Configuracion.
     
        FIND B-PedM WHERE ROWID(B-PedM) = D-ROWID EXCLUSIVE-LOCK . 
        s-codalm = B-PedM.codalm.   /* << OJO << lo tomamos del pedido */

        /* Control de documentos Guia de Remision por terminal */
        FIND FIRST ccbdterm WHERE CcbDTerm.CodCia = s-codcia AND
            CcbDTerm.CodDiv = s-coddiv AND
            CcbDTerm.CodDoc = F-coddoc AND
            CcbDTerm.CodTer = s-codter NO-LOCK NO-ERROR.
        IF NOT AVAILABLE ccbdterm
        THEN DO:
            MESSAGE "La factura no esta configurada en este terminal" VIEW-AS ALERT-BOX ERROR.
            RETURN "ADM-ERROR".
        END.
        s-ptovta = ccbdterm.nroser.

        CREATE B-CDocu.
        FIND faccorre WHERE 
             faccorre.codcia = s-codcia AND 
             faccorre.coddoc = F-coddoc AND
             faccorre.NroSer = s-ptovta EXCLUSIVE-LOCK NO-ERROR.
        IF AVAILABLE faccorre THEN 
           ASSIGN
                B-CDocu.nrodoc = STRING(faccorre.nroser, "999") + STRING(FacCorre.Correlativo, "999999")
                faccorre.correlativo = faccorre.correlativo + 1.
        RELEASE faccorre.
        ASSIGN B-CDOCU.CodCia  = S-CODCIA
               B-CDOCU.CodAlm  = CcbCDocu.CodAlm 
               B-CDOCU.CodDiv  = CcbCDocu.CodDiv 
               B-CDOCU.CodDoc  = F-CODDOC
               B-CDOCU.CodCli  = CcbCDocu.CodCli
               B-CDOCU.Nomcli  = CcbCDocu.Nomcli
               B-CDOCU.Dircli  = CcbCDocu.Dircli
               B-CDOCU.Ruccli  = CcbCDocu.Ruccli 
               B-CDOCU.CodVen  = CcbCDocu.CodVen
               B-CDOCU.CodMov  = CcbCDocu.CodMov 
               B-CDOCU.NroPed  = CcbCDocu.NroPed
               B-CDOCU.FmaPgo  = CcbCDocu.FmaPgo
               B-CDOCU.CodMon  = CcbCDocu.CodMon
               B-CDOCU.TpoCmb  = CcbCDocu.TpoCmb
               B-CDOCU.PorIgv  = CcbCDocu.PorIgv
               B-CDOCU.NroOrd  = CcbCDocu.NroOrd
               B-CDOCU.CodRef  = CcbCDocu.Coddoc 
               B-CDOCU.NroRef  = CcbCDocu.Nrodoc
               B-CDOCU.NroSal  = CcbCDocu.NroSal
               B-CDOCU.CodDpto = CcbCDocu.CodDpto
               B-CDOCU.CodProv = CcbCDocu.CodProv
               B-CDOCU.CodDist = CcbCDocu.CodDist
               B-CDOCU.FchDoc  = TODAY 
               B-CDOCU.FchVto  = TODAY 
               B-CDOCU.Tipo    = "CONTADO"
               B-CDOCU.TpoFac  = "C"
               B-CDOCU.TipVta  = "1"
               B-CDOCU.FlgEst  = "F"
               B-CDOCU.usuario = S-USER-ID
               B-CDOCU.ImpBrt  = 0
               B-CDOCU.ImpDto  = 0
               B-CDOCU.ImpExo  = 0
               B-CDOCU.ImpIgv  = 0
               B-CDOCU.ImpInt  = 0
               B-CDOCU.ImpIsc  = 0
               B-CDOCU.ImpTot  = 0
               B-CDOCU.ImpVta  = 0
               B-CDOCU.SdoAct  = 0
               CcbCDocu.FlgSit   = ""
               CcbCDocu.FlgCon   = ""
               CcbCDocu.CodRef   = B-CDOCU.CodDoc
               CcbCDocu.NroRef   = B-CDOCU.NroDoc.
        RELEASE B-CDocu.
     END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Ingreso-a-Caja Procedure 
PROCEDURE Ingreso-a-Caja :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FIND Faccorre WHERE FacCorre.CodCia = s-codcia AND
       FacCorre.CodDoc = "I/C" AND FacCorre.NroSer = s-sercja AND 
       FacCorre.CodDiv = s-coddiv EXCLUSIVE-LOCK.
       
  FIND FIRST T-CcbCCaja.
  
  CREATE CcbCCaja.
  ASSIGN
    CcbCCaja.CodCia    = s-codcia
    CcbCCaja.CodDiv    = s-coddiv 
    CcbCCaja.CodDoc    = "I/C"
    CcbCCaja.NroDoc    = STRING(FacCorre.NroSer, "999") + 
                         STRING(FacCorre.Correlativo, "999999")
    FacCorre.Correlativo = FacCorre.Correlativo + 1
    CcbCCaja.CodBco[2]  = T-CcbCCaja.CodBco[2] 
    CcbCCaja.CodBco[3]  = T-CcbCCaja.CodBco[3] 
    CcbCCaja.CodBco[4]  = T-CcbCCaja.CodBco[4] 
    CcbCCaja.CodBco[5]  = T-CcbCCaja.CodBco[5] 
    CcbCCaja.CodCli     = ccbcdocu.codcli
    CcbCCaja.NomCli     = CcbCDocu.NomCli
    CcbCCaja.CodMon     = ccbcdocu.codmon
    CcbCCaja.FchDoc     = TODAY
    CcbCCaja.ImpNac[1]  = T-CcbCCaja.ImpNac[1] 
    CcbCCaja.ImpNac[2]  = T-CcbCCaja.ImpNac[2] 
    CcbCCaja.ImpNac[3]  = T-CcbCCaja.ImpNac[3] 
    CcbCCaja.ImpNac[4]  = T-CcbCCaja.ImpNac[4] 
    CcbCCaja.ImpNac[5]  = T-CcbCCaja.ImpNac[5] 
    CcbCCaja.ImpNac[6]  = T-CcbCCaja.ImpNac[6] 
    CcbCCaja.ImpUsa[1]  = T-CcbCCaja.ImpUsa[1] 
    CcbCCaja.ImpUsa[2]  = T-CcbCCaja.ImpUsa[2] 
    CcbCCaja.ImpUsa[3]  = T-CcbCCaja.ImpUsa[3]
    CcbCCaja.ImpUsa[4]  = T-CcbCCaja.ImpUsa[4] 
    CcbCCaja.ImpUsa[5]  = T-CcbCCaja.ImpUsa[5] 
    CcbCCaja.ImpUsa[6]  = T-CcbCCaja.ImpUsa[6] 
    CcbCcaja.Tipo       = IF F-CODDOC = "FAC" THEN "CAFA" ELSE "CABO" 
    CcbCCaja.CodCaja    = S-CODTER
    CcbCCaja.TpoCmb     = T-CcbCCaja.TpoCmb
    CcbCCaja.usuario    = s-user-id
    CcbCCaja.Voucher[2] = T-CcbCCaja.Voucher[2]
    CcbCCaja.Voucher[3] = T-CcbCCaja.Voucher[3]
    CcbCCaja.Voucher[4] = T-CcbCCaja.Voucher[4] 
    CcbCCaja.Voucher[5] = T-CcbCCaja.Voucher[5] 
    CcbCCaja.Voucher[6] = T-CcbCCaja.Voucher[6] 
    CcbCCaja.FchVto[2]  = T-CcbCCaja.FchVto[2]
    CcbCCaja.FchVto[3]  = T-CcbCCaja.FchVto[3]
    CcbCCaja.VueNac     = T-CcbCCaja.VueNac 
    CcbCCaja.VueUsa     = T-CcbCCaja.VueUsa
    CcbCCaja.FLGEST     = "C".
    
    IF T-CcbCCaja.ImpNac[2] + T-CcbCCaja.ImpUsa[2] > 0 THEN DO :
       RUN ccb\R_cheque.p ("CHC", ccbcdocu.codcli, 
                           T-CcbCCaja.CodBco[2], T-CcbCCaja.Voucher[2],
                           T-CcbCCaja.ImpNac[2], T-CcbCCaja.ImpUsa[2],
                           T-CcbCCaja.FchVto[2] ). 
    END.
    IF T-CcbCCaja.ImpNac[3] + T-CcbCCaja.ImpUsa[3] > 0 THEN DO :
       RUN ccb\R_cheque.p ("CHD", ccbcdocu.codcli, 
                           T-CcbCCaja.CodBco[3], T-CcbCCaja.Voucher[3],
                           T-CcbCCaja.ImpNac[3], T-CcbCCaja.ImpUsa[3],
                           T-CcbCCaja.FchVto[3] ).        
    END.
    
  RELEASE faccorre.
  CREATE CcbDCaja.
  ASSIGN
    CcbDCaja.CodCia = s-codcia
    CcbDCaja.CodDoc = ccbccaja.coddoc
    CcbDCaja.NroDoc = ccbccaja.nrodoc
    CcbDCaja.CodRef = ccbcdocu.coddoc
    CcbDCaja.NroRef = ccbcdocu.nrodoc
    CcbDCaja.CodCli = ccbcdocu.codcli
    CcbDCaja.CodMon = ccbcdocu.codmon
    CcbDCaja.FchDoc = ccbccaja.fchdoc
    CcbDCaja.ImpTot = ccbcdocu.imptot
    CcbDCaja.TpoCmb = ccbccaja.tpocmb.
  ASSIGN
    ccbcdocu.flgest = "C"
    ccbcdocu.fchcan = TODAY
    ccbcdocu.sdoact = 0.
  RELEASE ccbccaja.
  RELEASE ccbdcaja.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Orden-de-despacho Procedure 
PROCEDURE Orden-de-despacho :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  /* Correlativo de Salida */
  FIND Almacen WHERE Almacen.CodCia = s-codcia AND
       Almacen.CodAlm = s-codalm EXCLUSIVE-LOCK NO-ERROR.
     
  CREATE almcmov.
  ASSIGN
    Almcmov.CodCia  = s-codcia
    Almcmov.CodAlm  = s-codalm
    Almcmov.TipMov  = "S"
    Almcmov.CodMov  = s-codmov
    Almcmov.NroSer  = s-ptovta
    Almcmov.NroDoc  = Almacen.CorrSal
    Almacen.CorrSal = Almacen.CorrSal + 1
    Almcmov.CodRef  = F-coddoc
    Almcmov.NroRef  = ccbcdocu.nrodoc
    Almcmov.NroRf1  = "F" + ccbcdocu.nrodoc
    Almcmov.Nomref  = ccbcdocu.nomcli
    Almcmov.FchDoc  = TODAY
    Almcmov.HorSal  = STRING(TIME, "HH:MM:SS")
    Almcmov.CodVen  = ccbcdocu.CodVen
    Almcmov.CodCli  = ccbcdocu.CodCli
    Almcmov.usuario = s-user-id
    CcbcDocu.NroSal = STRING(Almcmov.NroDoc,"999999").
  RELEASE Almacen.
    
  DEF VAR i AS INTEGER INITIAL 1 NO-UNDO.
  FOR EACH ccbddocu OF ccbcdocu:
    CREATE Almdmov.
    ASSIGN
        Almdmov.CodCia = s-codcia
        Almdmov.CodAlm = s-codalm
        Almdmov.TipMov = "S"
        Almdmov.CodMov = s-codmov
        Almdmov.NroSer = almcmov.nroser
        Almdmov.NroDoc = almcmov.nrodoc
        Almdmov.NroItm = i
        Almdmov.codmat = ccbddocu.codmat
        Almdmov.CanDes = ccbddocu.candes
        Almdmov.AftIgv = ccbddocu.aftigv
        Almdmov.AftIsc = ccbddocu.aftisc
        Almdmov.CodMon = ccbcdocu.codmon
        Almdmov.CodUnd = ccbddocu.undvta
        Almdmov.Factor = ccbddocu.factor
        Almdmov.FchDoc = TODAY
        Almdmov.ImpDto = ccbddocu.impdto
        Almdmov.ImpIgv = ccbddocu.impigv
        Almdmov.ImpIsc = ccbddocu.impisc
        Almdmov.ImpLin = ccbddocu.implin
        Almdmov.PorDto = ccbddocu.pordto
        Almdmov.PreBas = ccbddocu.prebas
        Almdmov.PreUni = ccbddocu.preuni
        Almdmov.TpoCmb = ccbcdocu.tpocmb
        Almcmov.TotItm = i
        i = i + 1.
        RUN alm/almdgstk (ROWID(almdmov)).
        RUN alm/almacpr1 (ROWID(almdmov), "U").
        RUN alm/almacpr2 (ROWID(almdmov), "U"). 
  END.  
  RELEASE almcmov.
  RELEASE almdmov.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


