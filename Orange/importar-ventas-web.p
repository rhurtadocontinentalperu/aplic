DEF NEW SHARED VAR s-codcia AS INT INIT 001.
DEF NEW SHARED VAR cb-codcia AS INT INIT 000.
DEF NEW SHARED VAR pv-codcia AS INT INIT 000.
DEF NEW SHARED VAR s-coddiv AS CHAR INIT '00500'.
DEF NEW SHARED VAR s-codalm AS CHAR INIT '500'.
DEF NEW SHARED VAR s-user-id AS CHAR INIT 'SISTEMAS'.
DEF VAR s-nroitm AS INT NO-UNDO.
DEF VAR s-coddoc AS CHAR NO-UNDO.
DEF VAR s-nrodoc AS CHAR NO-UNDO.
DEF VAR s-codmat AS CHAR NO-UNDO.
DEFINE VARIABLE I-NRODOC       AS INTEGER NO-UNDO.
DEFINE VARIABLE I-NROSER       AS INTEGER NO-UNDO.

DEFINE VARIABLE OKpressed AS LOGICAL NO-UNDO.
DEFINE VARIABLE FILL-IN-file AS CHAR NO-UNDO.

SYSTEM-DIALOG GET-FILE FILL-IN-file
    FILTERS "Archivos Excel (*.xls)" "*.xls,*.xlsx", "Todos (*.*)" "*.*"
    TITLE "Archivo(s) de Carga..."
    MUST-EXIST
    USE-FILENAME
    UPDATE OKpressed.
IF OKpressed = FALSE THEN RETURN.

/* 1ro Migramos la información a Detalle */
DEFINE VARIABLE chExcelApplication  AS COM-HANDLE.
DEFINE VARIABLE chWorkbook          AS COM-HANDLE.
DEFINE VARIABLE chWorksheet         AS COM-HANDLE.
DEFINE VARIABLE cRange          AS CHARACTER    NO-UNDO.
DEFINE VARIABLE iCountLine      AS INTEGER      NO-UNDO.
DEFINE VARIABLE iTotalColumn    AS INTEGER      NO-UNDO.
DEFINE VARIABLE cValue          AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cValueX          AS CHARACTER    NO-UNDO.
DEFINE VARIABLE iValue          AS INTEGER      NO-UNDO.
DEFINE VARIABLE dValue          AS DECIMAL      NO-UNDO.
DEFINE VARIABLE t-Column        AS INTEGER INIT 1.
DEFINE VARIABLE t-Row           AS INTEGER INIT 1.
DEFINE VARIABLE i-Column        AS INTEGER     NO-UNDO.

DEFINE TEMP-TABLE t-cdocu LIKE ccbcdocu.
DEFINE TEMP-TABLE t-ddocu LIKE ccbddocu
    INDEX Idx00 AS PRIMARY codcia coddiv coddoc nrodoc.

CREATE "Excel.Application" chExcelApplication.
chWorkbook = chExcelApplication:Workbooks:OPEN(FILL-IN-file).
chWorkSheet = chExcelApplication:Sheets:ITEM(1).

/* CARGAMOS EL TEMPORAL */
ASSIGN
    s-nroitm = 0
    t-Column = 0
    t-Row = 1.     /* Saltamos el encabezado de los campos */
REPEAT:
    ASSIGN
        s-nroitm = s-nroitm + 1
        t-column = 0
        t-Row    = t-Row + 1.
    t-column = t-column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    IF cValue = "" OR cValue = ? THEN LEAVE.    /* FIN DE DATOS */ 
    cValue = STRING(DECIMAL(cValue),'99999999999').
    
    CREATE t-ddocu.
    ASSIGN
        t-ddocu.codcia = s-codcia
        t-ddocu.nroitm = s-nroitm
        t-ddocu.coddiv = s-coddiv
        t-ddocu.coddoc = (IF cValue BEGINS '3' THEN 'N/C' ELSE 'FAC')
        t-ddocu.nrodoc = SUBSTRING(cValue,2,3) + SUBSTRING(cValue,6)
        t-ddocu.almdes = s-codalm.
    FIND t-cdocu OF t-ddocu NO-ERROR.
    IF NOT AVAILABLE t-cdocu THEN DO:
        CREATE t-cdocu.
        BUFFER-COPY t-ddocu TO t-cdocu ASSIGN t-cdocu.usuario = s-user-id.
    END.
        
    t-Column = t-Column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    ASSIGN
        t-ddocu.fchdoc = DATE(cValue).

    t-Column = t-Column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    ASSIGN
        t-cdocu.fchvto = DATE(cValue).

    t-Column = t-Column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    ASSIGN
        t-ddocu.codcli = STRING(DECIMAL(cValue),'99999999999').

    t-Column = t-Column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    ASSIGN
        t-cdocu.nomcli = cValue.

    BUFFER-COPY t-ddocu TO t-cdocu 
        ASSIGN 
        t-cdocu.flgest = 'P'
        t-cdocu.ruccli = t-cdocu.codcli
        t-cdocu.porigv = 18.00
        t-cdocu.codalm = s-codalm
        t-cdocu.codven = '020'
        t-cdocu.codmov = (IF t-cdocu.coddoc = 'N/C' THEN 09 ELSE 02)
        t-cdocu.CndCre = 'D'.
    FIND LAST gn-tcmb WHERE gn-tcmb.fecha <= t-cdocu.fchdoc NO-LOCK NO-ERROR.
    IF AVAILABLE gn-tcmb THEN t-cdocu.tpocmb = gn-tcmb.venta.
    
    t-Column = t-Column + 2.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    ASSIGN
        t-cdocu.codmon = (IF cValue = 'USD' THEN 2 ELSE 1).

    t-Column = t-Column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    ASSIGN
        t-cdocu.glosa = cValue.

    t-Column = t-Column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    ASSIGN
        t-cdocu.fmapgo = STRING(INT(cValue)).

    t-Column = t-Column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    IF t-cdocu.coddoc = 'N/C' THEN DO:
        ASSIGN
            t-cdocu.codref = 'FAC'
            t-cdocu.nroref = SUBSTRING(cValue,2,3) + SUBSTRING(cValue,6).
    END.

    t-Column = t-Column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    ASSIGN
        t-ddocu.codmat = STRING(INT(cValue), '999999').

    t-Column = t-Column + 2.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    ASSIGN
        t-ddocu.candes = DECIMAL(cValue).

    t-Column = t-Column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    ASSIGN
        t-ddocu.preuni = DECIMAL(cValue).

    t-Column = t-Column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    ASSIGN
        t-ddocu.implin = DECIMAL(cValue).

END.
chExcelApplication:QUIT().
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet. 

DEF TEMP-TABLE tt-ddocu LIKE t-ddocu.
FOR EACH t-ddocu, FIRST almmmatg OF t-ddocu NO-LOCK.
    ASSIGN
        t-ddocu.undvta = almmmatg.undbas
        t-ddocu.factor = 1.
END.
FOR EACH t-ddocu:
    t-ddocu.preuni = ABS(t-ddocu.preuni).
    t-ddocu.implin = ABS(t-ddocu.implin).
    t-ddocu.candes = ABS(t-ddocu.candes).
    FIND FIRST tt-ddocu WHERE tt-ddocu.coddoc = t-ddocu.coddoc
        AND tt-ddocu.nrodoc = t-ddocu.nrodoc
        AND tt-ddocu.codmat = t-ddocu.codmat
        NO-ERROR.
    IF NOT AVAILABLE tt-ddocu THEN CREATE tt-ddocu.
    BUFFER-COPY t-ddocu TO tt-ddocu
        ASSIGN 
        tt-ddocu.candes = tt-ddocu.candes + t-ddocu.candes
        tt-ddocu.implin = tt-ddocu.implin + t-ddocu.implin.
END.
EMPTY TEMP-TABLE t-ddocu.
FOR EACH t-cdocu WHERE t-cdocu.fchdoc > 03/31/2015:
    DELETE t-cdocu.
END.
s-nroitm = 0.
FOR EACH t-cdocu:
    s-nroitm = 0.
    FOR EACH tt-ddocu OF t-cdocu BY tt-ddocu.nroitm:
        s-nroitm = s-nroitm + 1.
        CREATE t-ddocu.
        BUFFER-COPY tt-ddocu TO t-ddocu ASSIGN t-ddocu.nroitm = s-nroitm.
    END.
END.

trloop:
FOR EACH t-cdocu WHERE t-cdocu.fchdoc <= 03/31/2015 TRANSACTION ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
    CREATE ccbcdocu.
    BUFFER-COPY t-cdocu TO ccbcdocu.
    FOR EACH t-ddocu OF t-cdocu BY t-ddocu.nroitm:
        CREATE ccbddocu.
        BUFFER-COPY t-ddocu TO ccbddocu.
        /* CORREGIMOS IMPORTES */
        IF Ccbddocu.Por_Dsctos[1] = 0 AND Ccbddocu.Por_Dsctos[2] = 0 AND Ccbddocu.Por_Dsctos[3] = 0 
            THEN Ccbddocu.ImpDto = 0.
        ELSE Ccbddocu.ImpDto = Ccbddocu.CanDes * Ccbddocu.PreUni - Ccbddocu.ImpLin.
        ASSIGN
            Ccbddocu.ImpLin = ROUND(Ccbddocu.ImpLin, 2)
            Ccbddocu.ImpDto = ROUND(Ccbddocu.ImpDto, 2).
        IF Ccbddocu.AftIsc 
            THEN Ccbddocu.ImpIsc = ROUND(Ccbddocu.PreBas * Ccbddocu.CanDes * (Almmmatg.PorIsc / 100),4).
        ELSE Ccbddocu.ImpIsc = 0.
        IF Ccbddocu.AftIgv 
            THEN Ccbddocu.ImpIgv = Ccbddocu.ImpLin - ROUND( Ccbddocu.ImpLin  / ( 1 + (Ccbcdocu.PorIgv / 100) ), 4 ).
        ELSE Ccbddocu.ImpIgv = 0.
    END.
    {vta2/graba-totales-factura-cred.i}

    CASE TRUE:
        WHEN LOOKUP(Ccbcdocu.coddoc, 'FAC,BOL,TCK') > 0 THEN DO:
            RUN act_alm (ROWID(CcbCDocu)).
            IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO trloop, LEAVE.
        END.
        WHEN Ccbcdocu.coddoc = 'N/C' THEN DO:
            RUN ing-devo-utilex (ROWID(Ccbcdocu)).
            IF RETURN-VALUE = "ADM-ERROR" THEN UNDO trloop, LEAVE.
        END.
    END CASE.
END.

PROCEDURE act_alm:
/* ************** */

    DEFINE INPUT PARAMETER X-ROWID AS ROWID.

    FIND ccbcdocu WHERE ROWID(ccbcdocu) = X-ROWID NO-LOCK NO-ERROR.
    IF NOT AVAILABLE ccbcdocu THEN RETURN "OK".

    DEF VAR s-NroSer AS INT NO-UNDO.
    DEF VAR s-NroDoc AS INT NO-UNDO.

    ASSIGN
        s-NroSer = 0
        s-NroDoc = 0.
    FIND gn-divi WHERE gn-divi.codcia = ccbcdocu.codcia AND gn-divi.coddiv = ccbcdocu.coddiv
         NO-LOCK NO-ERROR.                                                                    

    DEF VAR i AS INTEGER INITIAL 1 NO-UNDO.
    DEF VAR LocalCounter AS INTEGER INITIAL 0 NO-UNDO.
    DEF VAR x-CorrSal LIKE Almacen.CorrSal NO-UNDO.
    DEF VAR x-FchDoc AS DATE NO-UNDO.

    PRINCIPAL:
    DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN 'ADM-ERROR':
        FOR EACH Ccbddocu OF Ccbcdocu NO-LOCK WHERE Ccbddocu.implin >= 0 BREAK BY Ccbddocu.AlmDes:
            IF FIRST-OF(Ccbddocu.AlmDes) THEN DO:
                /* CABECERA */
                IF s-NroSer = 0 THEN DO:
                    /* EN CASO DE NO SER UNA VENTA UTILEX EL CORRELATIVO VA POR ALMACEN */
                    LocalCounter = 0.
                    GetLock:
                    REPEAT ON STOP UNDO, RETRY GetLock ON ERROR UNDO, LEAVE GetLock:
                        IF RETRY THEN DO:
                            LocalCounter = LocalCounter + 1.
                            IF LocalCounter = 5 THEN LEAVE GetLock.
                        END.
                        FIND Almacen WHERE Almacen.CodCia = Ccbddocu.codcia 
                            AND Almacen.CodAlm = Ccbddocu.almdes       
                            EXCLUSIVE-LOCK NO-ERROR.
                        IF AVAILABLE Almacen THEN LEAVE.
                    END.
                    IF LocalCounter = 5 OR NOT AVAILABLE Almacen THEN DO:
                        MESSAGE 'NO se pudo bloquear el almacén:' Ccbddocu.almdes SKIP
                            'Proceso Abortado'
                            VIEW-AS ALERT-BOX ERROR.
                        UNDO PRINCIPAL, RETURN 'ADM-ERROR'.
                    END.
                    REPEAT:
                        ASSIGN
                            x-CorrSal = Almacen.CorrSal.
                        IF NOT CAN-FIND(FIRST Almcmov WHERE Almcmov.codcia = CcbDDocu.CodCia 
                                        AND Almcmov.codalm = CcbDDocu.AlmDes
                                        AND Almcmov.tipmov = "S"
                                        AND Almcmov.codmov = 02
                                        AND Almcmov.nroser = s-NroSer
                                        AND Almcmov.nrodoc = x-CorrSal
                                        NO-LOCK)
                            THEN LEAVE.
                        ASSIGN
                            Almacen.CorrSal = Almacen.CorrSal + 1.
                    END.
                    ASSIGN
                        s-NroDoc = Almacen.CorrSal
                        Almacen.CorrSal = Almacen.CorrSal + 1.
                END.

                /* ************************* */
                IF YEAR(ccbcdocu.fchdoc) <= 2014 THEN x-fchdoc = 12/31/2014.
                ELSE x-fchdoc = 03/31/2015.
                CREATE almcmov.
                ASSIGN Almcmov.CodCia  = CcbDDocu.CodCia 
                       Almcmov.CodAlm  = CcbDDocu.AlmDes
                       Almcmov.TipMov  = "S"
                       Almcmov.CodMov  = 02     
                       Almcmov.NroSer  = s-NroSer
                       Almcmov.NroDoc  = s-NroDoc 
                       /*Almcmov.NroDoc  = Almacen.CorrSal */
                       /*Almacen.CorrSal = Almacen.CorrSal + 1*/
                       Almcmov.FchDoc  = x-FchDoc
                       Almcmov.HorSal  = STRING(TIME, "HH:MM:SS")
                       Almcmov.CodVen  = ccbcdocu.CodVen
                       Almcmov.CodCli  = ccbcdocu.CodCli
                       Almcmov.Nomref  = ccbcdocu.NomCli
                       Almcmov.CodRef  = ccbcdocu.CodDoc
                       Almcmov.NroRef  = ccbcdocu.nrodoc
                       Almcmov.NroRf1  = STRING(CcbCDocu.CodDoc, 'x(3)') + CcbCDocu.NroDoc
                       Almcmov.NroRf2  = CcbCDocu.CodPed + CcbCDocu.NroPed
                       Almcmov.usuario = s-user-id
                    NO-ERROR.
                IF ERROR-STATUS:ERROR THEN DO:
                    MESSAGE 'ERROR en cabecera de almacenes' VIEW-AS ALERT-BOX ERROR.
                    UNDO PRINCIPAL, RETURN "ADM-ERROR".
                END.
            END.
            /* DETALLE */
            CREATE Almdmov.
            ASSIGN Almdmov.CodCia = Almcmov.CodCia
                   Almdmov.CodAlm = Almcmov.CodAlm
                   Almdmov.CodMov = Almcmov.CodMov 
                   Almdmov.NroSer = almcmov.nroser
                   Almdmov.NroDoc = almcmov.nrodoc
                   Almdmov.AftIgv = ccbddocu.aftigv
                   Almdmov.AftIsc = ccbddocu.aftisc
                   Almdmov.CanDes = ccbddocu.candes
                   Almdmov.codmat = ccbddocu.codmat
                   Almdmov.CodMon = ccbcdocu.codmon
                   Almdmov.CodUnd = ccbddocu.undvta
                   Almdmov.Factor = ccbddocu.factor
                   Almdmov.FchDoc = almcmov.FchDoc
                   Almdmov.ImpDto = ccbddocu.impdto
                   Almdmov.ImpIgv = ccbddocu.impigv
                   Almdmov.ImpIsc = ccbddocu.impisc
                   Almdmov.ImpLin = ccbddocu.implin
                   Almdmov.NroItm = i
                   Almdmov.PorDto = ccbddocu.pordto
                   Almdmov.PreBas = ccbddocu.prebas
                   Almdmov.PreUni = ccbddocu.preuni
                   Almdmov.TipMov = "S"
                   Almdmov.TpoCmb = ccbcdocu.tpocmb
                   Almcmov.TotItm = i
                   Almdmov.HraDoc = Almcmov.HorSal
                   i = i + 1.
            RUN alm/almdcstk (ROWID(almdmov)).
            IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO PRINCIPAL, RETURN 'ADM-ERROR'.
            /* RHC 05.04.04 ACTIVAMOS KARDEX POR ALMACEN */
            RUN alm/almacpr1 (ROWID(almdmov), 'U').
            IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO PRINCIPAL, RETURN 'ADM-ERROR'.
        END.
        IF AVAILABLE(Almacen) THEN RELEASE Almacen.
        IF AVAILABLE(Almcmov) THEN RELEASE Almcmov.
        IF AVAILABLE(Almdmov) THEN RELEASE Almdmov.
    END.
    RETURN 'OK'.

END PROCEDURE.

PROCEDURE ing-devo-utilex:
/* ********************** */

    DEFINE INPUT PARAMETER X-ROWID AS ROWID.

    DEFINE VAR s-codcia AS INT.
    DEFINE VAR s-coddiv AS CHAR.
    DEFINE VAR s-codalm AS CHAR.
    DEFINE VAR s-codmov AS INT.
    DEFINE VAR s-NroSer AS INT.

/*     DEFINE VARIABLE S-CODDOC AS CHAR INITIAL "D/F". */
/*     DEFINE VARIABLE I-NROSER       AS INTEGER NO-UNDO. */
/*     DEFINE VARIABLE I-NRODOC       AS INTEGER NO-UNDO. */
    ASSIGN
        s-coddoc = "D/F"
        i-nroser = 0
        i-nrodoc = 0.
    DEFINE VARIABLE x-FchDoc AS DATE NO-UNDO.


    DEF VAR i AS INTEGER INITIAL 1 NO-UNDO.
    DEF VAR LocalCounter AS INTEGER INITIAL 0 NO-UNDO.

    PRINCIPAL:
    DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN 'ADM-ERROR':
        FIND ccbcdocu WHERE ROWID(ccbcdocu) = X-ROWID EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE ccbcdocu THEN RETURN "OK".
        ASSIGN
            s-codcia = Ccbcdocu.codcia
            s-coddiv = Ccbcdocu.coddiv
            s-codalm = Ccbcdocu.codalm
            s-codmov = 09.              /* Devolución de Clientes */

        FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.

        s-NroSer = 0.
        IF LOOKUP(s-coddiv, '00501,00023,00027,00502,00503') > 0 THEN s-NroSer = 999.

        /* CABECERA */
        LocalCounter = 0.
        GetLock:
        REPEAT ON STOP UNDO, RETRY GetLock ON ERROR UNDO, LEAVE GetLock:
            IF RETRY THEN DO:
                LocalCounter = LocalCounter + 1.
                IF LocalCounter = 5 THEN LEAVE GetLock.
            END.
            FIND Almacen WHERE Almacen.CodCia = Ccbcdocu.codcia 
                AND Almacen.CodAlm = Ccbcdocu.codalm
                EXCLUSIVE-LOCK NO-ERROR.
            IF AVAILABLE Almacen THEN LEAVE.
        END.
        IF LocalCounter = 5 OR NOT AVAILABLE Almacen THEN DO:
            MESSAGE 'NO se pudo bloquear el almacén:' Ccbcdocu.codalm SKIP
                'Proceso Abortado'
                VIEW-AS ALERT-BOX ERROR.
            UNDO PRINCIPAL, RETURN 'ADM-ERROR'.
        END.
        /* ************************* */
        x-FchDoc = (IF YEAR(Ccbcdocu.fchdoc) <= 2014 THEN 12/31/2014 ELSE 03/31/2015).
        CREATE almcmov.
        ASSIGN 
            Almcmov.CodCia = s-CodCia 
            Almcmov.CodAlm = s-CodAlm
            Almcmov.TipMov = "I"
            Almcmov.CodMov = s-CodMov
            Almcmov.NroSer = s-NroSer
            Almcmov.NroDoc = Almacen.CorrIng
            Almcmov.CodRef = ccbcdocu.CodDoc
            Almcmov.NroRef = ccbcdocu.nrodoc
            Almcmov.FchDoc = x-FchDoc
            Almcmov.HorSal = STRING(TIME, "HH:MM:SS")
            Almcmov.CodCli = ccbcdocu.CodCli
            Almcmov.Nomref = ccbcdocu.NomCli
            Almcmov.CodMon = Ccbcdocu.codmon
            Almcmov.TpoCmb = Ccbcdocu.tpocmb
            Almcmov.CodVen = ccbcdocu.CodVen
            Almcmov.NroRf1 = STRING(CcbCDocu.CodDoc, 'x(3)') + CcbCDocu.NroDoc
            Almcmov.usuario= s-user-id
            Almcmov.FlgEst = "C"        /* >>> OJO <<< */
            Almcmov.HorRcp = STRING(TIME,"HH:MM:SS")
            NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            MESSAGE 'ERROR en ingreso al almacén' VIEW-AS ALERT-BOX ERROR.
            UNDO PRINCIPAL, RETURN "ADM-ERROR".
        END.
        ASSIGN
            Almacen.CorrIng = Almacen.CorrIng + 1.

        RUN Numero-de-Documento(YES).
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO PRINCIPAL, RETURN 'ADM-ERROR'.
        ASSIGN
            Almcmov.NroRf2 = STRING(I-NroSer,"999") + STRING(I-NroDoc,"999999").
        ASSIGN
            CcbCDocu.NroOrd = Almcmov.NroRf2.

        /* DETALLE */
        FOR EACH Ccbddocu OF Ccbcdocu NO-LOCK BY Ccbddocu.NroItm:
            CREATE Almdmov.
            ASSIGN Almdmov.CodCia = Almcmov.CodCia
                   Almdmov.CodAlm = Almcmov.CodAlm
                   Almdmov.TipMov = Almcmov.TipMov
                   Almdmov.CodMov = Almcmov.CodMov 
                   Almdmov.NroSer = almcmov.nroser
                   Almdmov.NroDoc = almcmov.nrodoc
                   Almdmov.AftIgv = ccbddocu.aftigv
                   Almdmov.AftIsc = ccbddocu.aftisc
                   Almdmov.CanDes = ccbddocu.candes
                   Almdmov.codmat = ccbddocu.codmat
                   Almdmov.CodMon = ccbcdocu.codmon
                   Almdmov.CodUnd = ccbddocu.undvta
                   Almdmov.Factor = ccbddocu.factor
                   Almdmov.FchDoc = CcbCDocu.FchDoc
                   Almdmov.ImpIgv = ccbddocu.impigv
                   Almdmov.ImpIsc = ccbddocu.impisc
                   Almdmov.ImpLin = ccbddocu.implin
                   Almdmov.NroItm = i
                   Almdmov.PreBas = ccbddocu.prebas
                   Almdmov.PreUni = ccbddocu.preuni
                   Almdmov.TpoCmb = ccbcdocu.tpocmb
                   Almcmov.TotItm = i
                   Almdmov.HraDoc = Almcmov.HorRcp
                   i = i + 1.
        END.
        IF AVAILABLE(Almacen) THEN RELEASE Almacen.
        IF AVAILABLE(Almcmov) THEN RELEASE Almcmov.
        IF AVAILABLE(Almdmov) THEN RELEASE Almdmov.
        IF AVAILABLE(FacCorre) THEN RELEASE FacCorre.
    END.

    RETURN 'OK'.


END PROCEDURE.

PROCEDURE Numero-de-Documento:

    DEFINE INPUT PARAMETER L-INCREMENTA AS LOGICAL.

    IF L-INCREMENTA THEN 
       FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA 
                      AND  FacCorre.CodDoc = S-CODDOC 
                      AND  FacCorre.CodDiv = S-CODDIV 
                      AND  FAcCorre.CodAlm = S-CODALM
                     EXCLUSIVE-LOCK NO-ERROR.
    ELSE
       FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA 
                      AND  FacCorre.CodDoc = S-CODDOC 
                      AND  FacCorre.CodDiv = S-CODDIV
                      AND  FacCorre.CodAlm = S-CODALM 
                     NO-LOCK NO-ERROR.

    IF ERROR-STATUS:ERROR THEN DO:
        MESSAGE 'NO se encontró el control de correlativos para el documento' s-coddoc SKIP
            'para la división' s-coddiv 'para el almacén' s-codalm
            VIEW-AS ALERT-BOX ERROR.
        RETURN 'ADM-ERROR'.
    END.
    ASSIGN 
      I-NroDoc = FacCorre.Correlativo.
    IF L-INCREMENTA THEN ASSIGN FacCorre.Correlativo = FacCorre.Correlativo + 1.
    RETURN 'OK'.


END PROCEDURE.
