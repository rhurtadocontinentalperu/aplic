DEF VAR s-codcia AS INTE INIT 001 NO-UNDO.
DEF VAR cl-codcia AS INTE INIT 000 NO-UNDO.
DEF VAR s-coddiv AS CHAR NO-UNDO.
DEF VAR s-codcja AS CHAR INIT "I/C".
DEF VAR s-sercja AS INTE.
DEF VAR s-user-id AS CHAR INIT "ADMIN" NO-UNDO.
DEF VAR s-CodTer    LIKE ccbcterm.codter.
DEF VAR s-tipo   AS CHAR INIT "MOSTRADOR".
DEF VAR pNroDocCja AS CHAR NO-UNDO.
DEF VAR x-NroItm AS INT NO-UNDO.

DEF VAR FILL-IN_T_Compra AS DEC DECIMALS 4 NO-UNDO.
DEF VAR FILL-IN_T_Venta  AS DEC DECIMALS 4 NO-UNDO.

DEF VAR x-Rowid AS ROWID NO-UNDO.

/* DISABLE TRIGGERS FOR LOAD OF ccbcdocu. */
/* DISABLE TRIGGERS FOR LOAD OF ccbddocu. */

/* CHEQUEO PREVIO */
FOR EACH openventas WHERE OpenVentas.FlagMigracion = "N":
    FIND Almmmate WHERE Almmmate.codcia = s-codcia
        AND Almmmate.codalm = OpenVentas.CodAlm
        AND Almmmate.codmat = OpenVentas.codmat
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almmmate THEN DO:
        MESSAGE 'Producto' OpenVentas.codmat
            'NO asignado al almacén' OpenVentas.CodAlm SKIP
            'Proceso Abortado'
            VIEW-AS ALERT-BOX WARNING.
        RETURN.
    END.
END.

PRINCIPAL:
FOR EACH openventas WHERE OpenVentas.FlagMigracion = "N"
    BREAK BY OpenVentas.CodCaja 
    BY OpenVentas.usuario 
    BY OpenVentas.FchDoc 
    BY OpenVentas.HorCie
    BY OpenVentas.CodDoc 
    BY OpenVentas.NroDoc
    TRANSACTION ON ERROR UNDO, RETURN ON STOP UNDO, RETURN:
    IF FIRST-OF(OpenVentas.CodCaja)
        OR FIRST-OF(OpenVentas.usuario)
        OR FIRST-OF(OpenVentas.FchDoc)
        OR FIRST-OF(OpenVentas.HorCie)
        OR FIRST-OF(OpenVentas.CodDoc)
        OR FIRST-OF(OpenVentas.NroDoc)
        THEN DO:
        ASSIGN
            s-coddiv = OpenVentas.coddiv
            s-codter = Openventas.codcaja.
        FIND FIRST ccbdterm WHERE CcbDTerm.CodCia = s-codcia 
            AND CcbDTerm.CodDiv = s-coddiv 
            AND CcbDTerm.CodDoc = s-codcja 
            AND CcbDTerm.CodTer = s-codter NO-LOCK NO-ERROR.
        IF NOT AVAILABLE ccbdterm THEN DO:
            MESSAGE
                "EL DOCUMENTO I/CAJA NO ESTA CONFIGURADO EL TERMINAL" s-codter SKIP
                "PROCESO ABORTADO"
                VIEW-AS ALERT-BOX ERROR.
            UNDO PRINCIPAL, RETURN.
        END.
        s-sercja = ccbdterm.nroser.

        /* CREAMOS LA CABECERA DEL INGRESO A CAJA */
        RUN Ingreso-a-Caja (OUTPUT pNroDocCja).
        IF RETURN-VALUE = "ADM-ERROR" THEN UNDO PRINCIPAL, RETURN.

        /* CREAMOS COMPROBANTE */
        CREATE Ccbcdocu.
        ASSIGN
            CcbCDocu.CodCia = s-codcia
            CcbCDocu.CodDiv = s-coddiv
            CcbCDocu.CodDoc = OpenVentas.coddoc
            CcbCDocu.NroDoc = OpenVentas.nrodoc
            CcbCDocu.FchDoc = OpenVentas.fchdoc
            CcbCDocu.FchVto = OpenVentas.fchdoc
            CcbCDocu.CodAlm = OpenVentas.codalm
            CcbCDocu.CodCli = OpenVentas.codcli
            CcbCDocu.NomCli = OpenVentas.nomcli
            CcbCDocu.DirCli = OpenVentas.dircli
            CcbCDocu.RucCli = (IF OpenVentas.TpoDoc = "RUC" THEN OpenVentas.RucCli ELSE "")
            CcbCDocu.CodAnt = (IF OpenVentas.TpoDoc <> "RUC" THEN OpenVentas.RucCli ELSE "")
            CcbCDocu.FmaPgo = "000"
            CcbCDocu.Glosa  = OpenVentas.glosa
            CcbCDocu.Tipo   = s-tipo
            CcbCDocu.TipVta = "1"
            CcbCDocu.TpoFac = "C"
            CcbCDocu.CodMon = OpenVentas.codmon
            CcbCDocu.CodVen = OpenVentas.codven
            CcbCDocu.DivOri = s-coddiv
            CcbCDocu.FlgEst = OpenVentas.flgest
            CcbCDocu.ImpBrt = OpenVentas.impbrt
            CcbCDocu.ImpDto = OpenVentas.impdto
            CcbCDocu.ImpExo = OpenVentas.impexo
            CcbCDocu.ImpIgv = OpenVentas.impigv
            CcbCDocu.ImpTot = OpenVentas.imptot
            CcbCDocu.ImpVta = OpenVentas.impvta
            CcbCDocu.PorIgv = OpenVentas.porigv
            CcbCDocu.SdoAct = 0     /* OpenVentas.imptot */
            CcbCDocu.TpoCmb = FILL-IN_T_Compra  /* OpenVentas.tpocmb */
            CcbCDocu.UsuAnu = OpenVentas.usuanu
            CcbCDocu.usuario = OpenVentas.usuario
            CcbCDocu.ImpIsc = OpenVentas.impisc.
        /* DETALLE DE CAJA */
        FIND Ccbccaja WHERE Ccbccaja.codcia = s-codcia
            AND Ccbccaja.coddiv = s-coddiv
            AND Ccbccaja.coddoc = s-codcja
            AND Ccbccaja.nrodoc = pNroDocCja
            NO-LOCK.
        CREATE Ccbdcaja.
        ASSIGN
            CcbDCaja.CodCia = Ccbccaja.CodCia
            CcbdCaja.CodDiv = Ccbccaja.CodDiv
            CcbDCaja.CodDoc = Ccbccaja.CodDoc
            CcbDCaja.NroDoc = Ccbccaja.NroDoc
            CcbDCaja.CodRef = CcbCDocu.CodDoc
            CcbDCaja.NroRef = CcbCDocu.NroDoc
            CcbDCaja.CodCli = CcbCDocu.CodCli
            CcbDCaja.CodMon = CcbCDocu.CodMon
            CcbDCaja.FchDoc = Ccbccaja.FchDoc
            CcbDCaja.ImpTot = CcbCDocu.ImpTot
            CcbDCaja.TpoCmb = Ccbccaja.TpoCmb.
        /* CANCELAMOS EL COMPROBANTE */
        ASSIGN
            CcbCDocu.FlgEst = "C"
            CcbCDocu.FchCan = TODAY
            CcbCDocu.SdoAct = 0
            x-NroItm = 0
            x-Rowid = ROWID(Ccbcdocu).
        /* CREAMOS CLIENTE */
        FIND gn-clie WHERE gn-clie.codcia = cl-codcia
            AND gn-clie.codcli = Ccbcdocu.codcli
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE gn-clie THEN DO:
            CREATE gn-clie.
            ASSIGN 
                gn-clie.CodCia     = cl-codcia
                gn-clie.CodCli     = Ccbcdocu.CodCli 
                gn-clie.NomCli     = Ccbcdocu.NomCli 
                gn-clie.DirCli     = Ccbcdocu.DirCli 
                gn-clie.Ruc        = Ccbcdocu.RucCli 
                gn-clie.DNI        = Ccbcdocu.CodAnt
                gn-clie.clfCli     = "C" 
                gn-clie.CodPais    = "01" 
                gn-clie.Fching     = TODAY 
                gn-clie.usuario    = Ccbcdocu.Usuario
                gn-clie.TpoCli     = "1"
                gn-clie.CodDiv     = Ccbcdocu.CODDIV.

             /* RHC 07.03.05 valores de linea de credito por defecto */
             ASSIGN
                 gn-clie.FlgSit = 'A'    /* Activo */
                 gn-clie.FlagAut = 'A'   /* Autorizado */
                 gn-clie.ClfCli = 'C'.   /* Regular / Malo */
        END.
    END.
    /* DETALLE DEL COMPROBANTE */
    FIND Ccbddocu WHERE CcbDDocu.CodCia = s-codcia
        AND CcbDDocu.CodDiv = s-coddiv
        AND CcbDDocu.CodDoc = OpenVentas.CodDoc 
        AND CcbDDocu.NroDoc = OpenVentas.NroDoc 
        AND CcbDDocu.codmat = OpenVentas.CodMat
        NO-ERROR.
    IF NOT AVAILABLE Ccbddocu THEN DO:
        CREATE Ccbddocu.
        x-NroItm = x-NroItm + 1.
    END.
    ASSIGN
        CcbDDocu.CodCia = s-codcia
        CcbDDocu.CodDiv = s-coddiv
        CcbDDocu.CodDoc = OpenVentas.CodDoc 
        CcbDDocu.NroDoc = OpenVentas.NroDoc 
        CcbDDocu.FchDoc = OpenVentas.FchDoc
        CcbDDocu.NroItm = x-NroItm
        CcbDDocu.CodCli = OpenVentas.CodCli
        CcbDDocu.AlmDes = OpenVentas.CodAlm
        CcbDDocu.codmat = OpenVentas.CodMat
        CcbDDocu.AftIgv = OpenVentas.AftIgv
        CcbDDocu.AftIsc = OpenVentas.AftIsc
        CcbDDocu.CanDes = CcbDDocu.CanDes + OpenVentas.CanDes
        CcbDDocu.Factor = OpenVentas.Factor
        CcbDDocu.ImpIgv = CcbDDocu.ImpIgv + OpenVentas.ImpIgvLin
        CcbDDocu.ImpLin = CcbDDocu.ImpLin + OpenVentas.ImpLin
        CcbDDocu.PreBas = Ccbddocu.ImpLin / Ccbddocu.CanDes
        CcbDDocu.PreUni = Ccbddocu.ImpLin / Ccbddocu.CanDes
        CcbDDocu.UndVta = OpenVentas.UndVta.
    IF LAST-OF(OpenVentas.CodCaja)
        OR LAST-OF(OpenVentas.usuario)
        OR LAST-OF(OpenVentas.FchDoc)
        OR LAST-OF(OpenVentas.HorCie)
        OR LAST-OF(OpenVentas.CodDoc)
        OR LAST-OF(OpenVentas.NroDoc)
        THEN DO:

        /* Descarga de Almacen */
        FIND Ccbcdocu WHERE ROWID(Ccbcdocu) = x-Rowid.
        IF Ccbcdocu.flgest <> "A" THEN DO:
            RUN vta2/act_alm (ROWID(CcbCDocu)).
            IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO PRINCIPAL, RETURN.
        END.
    END.
    ASSIGN
        OpenVentas.FlagMigracion = "S"
        OpenVentas.FlagFechaHora = DATETIME(TODAY, MTIME)
        OpenVentas.FlagUsuario   = s-user-id.
END.

PROCEDURE Ingreso-a-Caja:

DEFINE OUTPUT PARAMETER para_nrodoccja LIKE Ccbccaja.NroDoc.

DEFINE VARIABLE x_NumDoc AS CHARACTER.

trloop:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* TIPO DE CAMBIO */
    FIND LAST Gn-tccja WHERE Gn-tccja.Fecha <= OpenVentas.FchDoc NO-LOCK NO-ERROR.
    IF AVAILABLE Gn-TcCja THEN DO:
        FILL-IN_T_Compra = Gn-Tccja.Compra.
        FILL-IN_T_Venta = Gn-Tccja.Venta.
    END.
    ELSE DO:
        FILL-IN_T_Compra = 0.
        FILL-IN_T_Venta = 0.
    END.

    FIND Faccorre WHERE
        FacCorre.CodCia = s-codcia AND
        FacCorre.CodDiv = s-coddiv AND
        FacCorre.CodDoc = s-codcja AND
        FacCorre.NroSer = s-sercja
        EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE FacCorre THEN UNDO, RETURN 'ADM-ERROR'.
    /* Crea Cabecera de Caja */
    CREATE Ccbccaja.
    ASSIGN
        Ccbccaja.CodCia     = s-CodCia
        Ccbccaja.CodDiv     = OpenVentas.CodDiv 
        Ccbccaja.CodDoc     = s-CodCja
        Ccbccaja.NroDoc     = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999")
        FacCorre.Correlativo = FacCorre.Correlativo + 1
        Ccbccaja.CodCaja    = OpenVentas.CodCaja
        Ccbccaja.usuario    = OpenVentas.usuario
        Ccbccaja.CodCli     = OpenVentas.codcli
        Ccbccaja.NomCli     = OpenVentas.NomCli
        Ccbccaja.CodMon     = OpenVentas.CodMon
        Ccbccaja.FchDoc     = OpenVentas.FchDoc
        Ccbccaja.ImpNac[1]  = OpenVentas.ImpNac1
        Ccbccaja.ImpNac[2]  = OpenVentas.ImpNac2
        Ccbccaja.ImpNac[3]  = OpenVentas.ImpNac3
        Ccbccaja.ImpNac[4]  = OpenVentas.ImpNac4
        Ccbccaja.ImpNac[5]  = OpenVentas.ImpNac5
        Ccbccaja.ImpNac[6]  = OpenVentas.ImpNac6
        Ccbccaja.ImpNac[7]  = OpenVentas.ImpNac7            
        Ccbccaja.ImpUsa[1]  = OpenVentas.ImpUsa1
        Ccbccaja.ImpUsa[2]  = OpenVentas.ImpUsa2
        Ccbccaja.ImpUsa[3]  = OpenVentas.ImpUsa3
        Ccbccaja.ImpUsa[4]  = OpenVentas.ImpUsa4 
        Ccbccaja.ImpUsa[5]  = OpenVentas.ImpUsa5
        Ccbccaja.ImpUsa[6]  = OpenVentas.ImpUsa6
        Ccbccaja.ImpUsa[7]  = OpenVentas.ImpUsa7
        Ccbccaja.Voucher[4] = OpenVentas.Voucher5   /* ó ¿7? */
        Ccbccaja.Voucher[5] = OpenVentas.Voucher8 
        Ccbccaja.Voucher[9] = OpenVentas.Voucher10
        Ccbccaja.CodBco[2]  = OpenVentas.Voucher2
        Ccbccaja.CodBco[3]  = OpenVentas.Voucher4
        Ccbccaja.CodBco[4]  = OpenVentas.Voucher6
        Ccbccaja.Tipo       = s-Tipo
        Ccbccaja.TpoCmb     = FILL-IN_T_Compra      /* OpenVentas.TpoCmb */
        Ccbccaja.VueNac     = OpenVentas.VueNac 
        Ccbccaja.VueUsa     = OpenVentas.VueUsa
        Ccbccaja.FLGEST     = OpenVentas.FlgEst.
    ASSIGN
        Ccbccaja.FlgCie = "C"
        Ccbccaja.FchCie = Ccbccaja.FchDoc.

    RELEASE faccorre.

    /* Captura Nro de Caja */
    para_nrodoccja = Ccbccaja.NroDoc.

END.
RETURN "OK".

END PROCEDURE.
